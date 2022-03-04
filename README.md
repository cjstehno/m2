# m2

A tool to help manage your local Maven repository.

## Building

TBD

## Running (Dev)

    dart run bin/scm.dart <args>

## Running Tests

	dart test

If the test mocks need to be updated, run:

	dart run build_runner build

## Features

### Stash the Local Maven Repo

You can cause your local Maven repo to be renamed to `repository_<name-suffix>` in order to force a full local refresh without
actually deleting the directory.

    m2 stash [-s | --suffix <name-suffix>]

Where the optional `-s` or `--suffix` will append the provided suffix, rather than the default `stashed` value.

You can revert the repo using the `m2 restore` command.

Note: If a stashed repository already exists with the specified (or default) name, an error will occur.

### Restore the Local Maven Repo

To restore a stashed repo you can run:

    m2 restore [-f | --force] [-s | --suffix <name-suffix>]

which will rename the `repository_<suffix-name>` directory to `repository`. If a repository directory already exists, you will
get an error and need to remove it yourself. The `-f` or `--force` flags will cause the existing `repository` directory
to be deleted before renaming the stashed directory.

The `-s` or `--suffix` options allow for spefication of the repository name suffix (defaults to `stashed`).

### List the Stashed Local Maven Repos

You can see what Maven local repositories you have stashed using the:

	m2 list
	
command. It will result in a list of the suffix names used to stash local repositories (without the `repository_` prefix).

### Delete the Local Maven Repo

To delete the local Maven repository, run:

    m2 delete [-s | --suffix <stash-suffix>]

If the `-s` or `--suffix` option is specified, it will delete the stashed repository with that suffix.

This operation is unrecoverable.
