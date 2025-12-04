# GenAI workshop using Python

## Environment setup

### Install uv if not already available

On a Linux/MacOS machine, run:
```
curl -LsSf https://astral.sh/uv/install.sh | sh
```
or on a windows machine run:
```
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```
For alternate methods, please refer to the uv installation instructions [here](https://docs.astral.sh/uv/getting-started/installation/).

### Grab your `PORTKEY_API_KEY` and define the `LLM_MODEL`
You can get your user API Portkey UI at `app.portkey.ai` and a model from the `ModelCatalog`. Set these as environment variables and run the scripts.

## Running the scripts

To execute any script, do:
```
uv run scipt-name.py
```
and provide any options if necessary.

Note that `uv` will automatically install the required version of Python and all the dependencies, create a venv for you which simplifies your workflow. If you prerfer, you can setup your own python environment via `pip/conda/pixi/etc`.
