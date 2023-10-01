# dbt_cemist_metadata
An ELT framework to extract CeMiSt metadata using dbt

### Usage
#### Clone
Clone this to your local computer:
```bash
git clone git@github.com:matinnuhamunada/dbt_cemist_metadata.git
```
#### Install dependencies
<details>
<summary>install using python venv</summary>

```bash
python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
```

</details>

<details>
<summary>install using mamba</summary>

```bash
mamba env create -f env.yml
```

</details>

#### Configure source location
Activate the virtual environment and configures source location by running this python script:

```bash
TO DO
```

#### Run DBT
```bash
dbt debug
dbt build
dbt docs generate
dbt docs serve
```

# Credits
This dbt template was inspired adapted from [jaffle_shop_duckdb](https://github.com/dbt-labs/jaffle_shop_duckdb) example.
