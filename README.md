# Taqueria docker action

A docker action that helps simplify and standardize the use of [Taqueria](https://taqueria.io/) in GitHub workflows

## Inputs

### `project_directory`

The name of the project directory. If nothing is specified the repository root directory is used.

### `task`

The name of a specific task to run. This input is mainly used for testing purposes.

### `plugins`

A comma separated list of plugins to install.

### `sandbox_name`

The name of the Flextesa sandbox to use. A sandbox will only be created if this input is specified. When running the sandbox, the action will automatically change the value of `rpcUrl` for the sandbox in `config.json`. This is to enable origination to the local sandbox in CI.

### `contracts`

A comma separated list of contracts to be added to the Taqueria project.

### `compile_command`

The compile command used to compile the contracts.

### `originate`

When set to true, contracts will be originated to the environment defined with the `environment` variable (leave empty for default). This option makes use of the `taquito` plugin so please make sure to install it.

### `tests`

When set to true, all tests in the `tests` directory will be run using the Jest plugin. This option makes use of the `jest` plugin so please make sure to install it. 

### `environment`

This input is used to select the configured environment for `taqueria` to originate to. The default is set to `development`.

### `taq_consent`

Whether or not to share action utilization data with Taqueria. Defaults to `True`. Set to `False` to opt out.

## Example usage

### Single step action
```yaml
- name: taqueria tasks
    uses: ecadlabs/taqueria-github-action@v0.2.0
    with:
        plugins: '@taqueria/plugin-ligo, @taqueria/plugin-flextesa, @taqueria/plugin-taquito'
        contracts: 'counter.jsligo'
        compile_command: compile 
        sandbox_name: local
        originate: 'true'
        tests: 'true'
```

### Multiple step action
```yaml
- name: compile contracts
    uses: ecadlabs/taqueria-github-action@v0.2.0
    with:
        project_directory: 'example-projects/hello-tacos'
        contracts: 'hello-tacos.mligo'
        compile_command: 'compile'

- name: start local sandbox
    uses: ecadlabs/taqueria-github-action@v0.2.0
    with:
        project_directory: 'example-projects/hello-tacos'
        sandbox_name: 'local'

- name: originate contracts
    uses: ecadlabs/taqueria-github-action@v0.2.0
    with:
        project_directory: 'example-projects/hello-tacos'
        originate: 'true'

- name: originate contracts
    uses: ecadlabs/taqueria-github-action@v0.2.0
    with:
        project_directory: 'example-projects/hello-tacos'
        tests: 'true'
```