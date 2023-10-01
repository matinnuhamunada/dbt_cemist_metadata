import yaml
import pandas as pd
from pathlib import Path
import logging

import argparse  # Import the argparse module


log_format = "%(levelname)-8s %(asctime)s   %(message)s"
date_format = "%d/%m %H:%M:%S"
logging.basicConfig(format=log_format, datefmt=date_format, level=logging.DEBUG)


def clean_raw_excel_cemist_metadata(dbt_profile_path, outdir="data_warehouse/soil",
                                    column_to_exclude=['Sample no.', 'Created from CeMiSt A Code',
                                                       'CeMiSt\nPlasmid ID', 'Extract no.']):
    """
    This function cleans raw excel files and converts them to parquet format. It excludes specified columns and 
    converts the remaining DataFrame to parquet and CSV formats which are saved in the specified output directory.

    :param dbt_profile_path: Path to the dbt profile.
    :param outdir: The output directory to save the parquet and CSV files. Default is 'data_warehouse/soil'.
    :param column_to_exclude: List of columns to exclude from the DataFrame. Default is 
                              ['Sample no.', 'Created from CeMiSt A Code','CeMiSt\nPlasmid ID', 'Extract no.'].
    """
    dbt_profile_path = Path(dbt_profile_path)
    dbt_dir = dbt_profile_path.parent

    logging.debug(f"Using dbt profile from directory: {dbt_dir.resolve()}")

    with open(str(dbt_profile_path), "r") as f:
        profile = yaml.safe_load(f)

    # Obtain the root directory for external data
    external_root = dbt_dir / profile["dbt_cemist"]["outputs"]["dev"]["external_root"]
    logging.debug(f"Reading external data from: {external_root.resolve()}")

    metadata = {}

    logging.info("Processing excel files...")
    logging.debug(f"Excluding columns: {column_to_exclude}")

    # Loop over all excel files starting with 'CeMiSt' in external_root
    excel_files = [i for i in external_root.glob("*.xlsx") if i.name.startswith("CeMiSt")]
    for m in excel_files:
        logging.debug(f"Reading file: {m.name}")

        # Construct metadata_id by replacing space with '__' in the file stem
        metadata_id = m.stem.replace(" ", "__")

        # Read the excel file into a DataFrame
        df = pd.read_excel(m)
        logging.debug("Dropping empty rows...")
        logging.debug(f"Original row length: {len(df)}")

        # Drop rows where all columns, excluding specified columns, are NaN
        df = df[df[[i for i in df.columns if i not in column_to_exclude]].notna().any(axis=1)]
        logging.debug(f"Cleaned row length: {len(df)}")

        # Store path and DataFrame in metadata dictionary
        metadata[metadata_id] = {"path": m, "dataframe": df}

    logging.debug(f"Replacing illegal SQL column character with '_'")
    for k, v in metadata.items():
        df = v["dataframe"]

        # Replace illegal SQL column characters with '_'
        df.columns = df.columns.map(
            lambda x: x.replace(' ', '_').replace('\n', '').replace("(", "_").replace(")", "_").replace(",", "_")
                .replace(".", "_").replace("/", "_").replace("?", "_").lower()
        )
        v["dataframe"] = df

    logging.info(f"Writing output files to: {outdir}")
    outdir = Path(outdir)
    outdir.mkdir(parents=True, exist_ok=True)

    # Convert DataFrame to parquet and CSV formats and save to outdir
    for k, v in metadata.items():
        outfile = outdir / f"{k}.parquet"
        logging.info(f"Converting {k} to parquet: {outfile}")
        df = v["dataframe"]

        # Convert 'date' column to datetime format and format as string
        if 'date' in df.columns:
            df['date'] = pd.to_datetime(df['date'], errors='coerce').dt.strftime('%d-%m-%Y')

        # Construct prefix from metadata key
        prefix = k.split("_")
        prefix = "".join([prefix[1][0], prefix[2][0], prefix[0][:2]])

        # Construct 'pid' column and set as index
        pid_terms = ["sample_no_", "extract_no_", "cemistplasmid_id"]
        for pid_term in pid_terms:
            if pid_term in df.columns:
                logging.debug(f"Using {pid_term} to label items in {k} with prefix: {prefix}")
                df['pid'] = df[pid_term].apply(lambda x: f"{prefix}{str(x).zfill(4)}")
                df = df.set_index('pid')

        # Convert all columns to string type
        df = df.astype(str)
        logging.info(f"Writing output files: {outfile}")

        # Write to parquet and CSV formats
        df.to_parquet(outfile)
        df.to_csv(str(outfile).replace(".parquet", ".csv"))


def main():
    parser = argparse.ArgumentParser(description='Clean raw Excel files and convert to Parquet format for dbt processing.')
    parser.add_argument('dbt_profile_path', help='The path to the dbt profile.')
    parser.add_argument('--outdir', default='data_warehouse/soil', help='The output directory to save the parquet and CSV files.')
    parser.add_argument('--columns_to_exclude', nargs='+', default=['Sample no.', 'Created from CeMiSt A Code', 'CeMiSt\nPlasmid ID', 'Extract no.'],
                        help='List of columns to exclude from the DataFrame.')
    
    args = parser.parse_args()  # Parse the arguments
    
    # Call the function with the parsed arguments
    clean_raw_excel_cemist_metadata(dbt_profile_path=args.dbt_profile_path,
                                    outdir=args.outdir,
                                    column_to_exclude=args.columns_to_exclude)

if __name__ == "__main__":
    main()

