# Taqueria docker action

This action runs taqueria commands in a docker image. The `taq init` is always run before any other commands.

## Inputs

### `project_directory`

The name of the project directory. If nothing is specified the repository root directory is used.

### `task`

The name of a specific task to run. This input is mainly used for testing purposes.

### `plugins`

A comma separated list of plugins to install.

### `sandbox_name`

The name of the Flextesa sandbox to use. A sandbox will only be created if this input is specified.

### `compile_command`

The compile command used to compile the contracts.

### `originate`

Whether or not to originate the contracts to the target environment. Can be 'yes' or 'no' and defaults to 'yes'. This option makes use of the `taquito` plugin so please make sure to install it. 

### `environment`

This input is used to select the configured environment for `taqueria` to originate to. The default is set to `development`.

## Example usage

### Single step action
```yaml
- name: taqueria tasks
    uses: ecadlabs/taqueria-github-action@v0.0.1-rc3
    with:
        plugins: '@taqueria/plugin-ligo@0.0.0-pr-741-86f0b45e, @taqueria/plugin-flextesa@0.0.0-pr-741-86f0b45e, @taqueria/plugin-taquito@0.0.0-pr-741-86f0b45e'
        compile_command: compile 
        sandbox_name: local
        originate: 'yes'
```

### Multiple step action
```yaml
- name: compile contracts
    uses: ./
    with:
        project_directory: 'example-projects/hello-tacos'
        compile_command: 'compile'

- name: start local sandbox
    uses: ./
    with:
        project_directory: 'example-projects/hello-tacos'
        sandbox_name: 'local'

- name: originate contracts
    uses: ./
    with:
        project_directory: 'example-projects/hello-tacos'
        originate: 'yes'
```