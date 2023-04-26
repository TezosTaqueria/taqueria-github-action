# Taqueria docker action

A docker action that helps simplify and standardize the use of [Taqueria](https://taqueria.io/) in GitHub workflows

## Taqueria version
`v0.28.0`

## Inputs

### `compile_contracts`

A list of contract file names to be compiled into Michelson. The artifacts are saved to the `artifacts` directory with the `.tz` extension.

### `compile_plugin`

The plugin used to compile the contracts. Can be `ligo` or `smartpy`. The default is `ligo`

### `deploy_contracts`

A list of Michelson smart contract files including the `.tz` extension to be deployed to a specified environment. The Taquito plugin needs to be installed.

### `environment`

This input is used to select the configured environment for `taqueria` to originate to. The default is set to `development`.

### `plugins`

A comma separated list of plugins to install.

### `ligo_libraries`

A comma seperated list. If compile plugin is "ligo" this parameter can be used to install ligo libraries. Example ligo/fa

### `taq_ligo_image`

A string representing ligo image to use. If compile plugin is "ligo" this parameter can be used to override the ligo image used. Example `ligolang/ligo_ci:next`


### `project_directory`

The name of the project directory. If nothing is specified the repository root directory is used.

### `sandbox_name`

The name of the Flextesa sandbox to use. A sandbox will only be created if this input is specified. When running the sandbox, the action will automatically change the value of `rpcUrl` for the sandbox in `config.json`. This is to enable origination to the local sandbox in CI.

### `task`

The name of a specific task to run. This input is mainly used for testing purposes.

### `test_plugin`

When set to jest, all tests in the `tests` directory will be run using the Jest plugin. This option makes use of the `jest` plugin so please make sure to install it. 

### `test_files`

When set to jest, all tests in the `tests` directory will be run using same plugin than the compile one. 


## Example usage

### Single step action
```yaml
- name: taqueria tasks
    uses: ecadlabs/taqueria-github-action@v0.13.0
    with:
        plugins: '@taqueria/plugin-ligo, @taqueria/plugin-flextesa, @taqueria/plugin-taquito, @taqueria/plugin-jest, @taqueria/plugin-smartpy'
        compile_contracts: counter.jsligo
        compile_plugin: ligo
        sandbox_name: local
        deploy_contracts: counter.tz
        tests: 'true'
```

### Multiple step action
```yaml
- name: compile contracts
    uses: ecadlabs/taqueria-github-action@v0.13.0
    with:
        project_directory: example-projects/taco-shop
        compile_contracts: hello-tacos.mligo
        compile_plugin: smartpy

- name: start local sandbox
    uses: ecadlabs/taqueria-github-action@v0.13.0
    with:
        project_directory: example-projects/taco-shop
        sandbox_name: local

- name: deploy contracts
    uses: ecadlabs/taqueria-github-action@v0.13.0
    with:
        project_directory: example-projects/taco-shop
        deploy_contracts: hello-tacos.tz
```
