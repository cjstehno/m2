# m2

A tool to help manage your local Maven repository.

## Building Executable

    dart compile exe bin/m2.dart -o dist/m2

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

    m2 stash <name-suffix>

Where the optional `<name-suffix>` argument will append the provided suffix, rather than the default `stashed` value.

You can revert the repo using the `m2 restore` command.

Note: If a stashed repository already exists with the specified (or default) name, an error will occur.

If you want to stash the repository, but leave the existing one intact, use the `-n | --no-delete` flag, which causes the
command to copy the repository rather than moving it.

### Restore the Local Maven Repo

To restore a stashed repo you can run:

    m2 restore [-f | --force] <name-suffix>

which will rename the `repository_<suffix-name>` directory to `repository`. If a repository directory already exists, you will
get an error and need to remove it yourself. The `-f` or `--force` flags will cause the existing `repository` directory
to be deleted before renaming the stashed directory.

The `<name-suffix>` argument allows for specification of the repository name suffix (defaults to `stashed`).

### List the Stashed Local Maven Repos

You can see what Maven local repositories you have stashed using the:

	m2 list
	
command. It will result in a list of the suffix names used to stash local repositories (without the `repository_` prefix).

### Delete the Local Maven Repo

To delete the local Maven repository, run:

    m2 delete <stash-suffix>

If a `<stash-suffix>` argument is specified, it will delete the stashed repository with that suffix, otherwise it will
delete the primary repository.

This operation is unrecoverable.

### Find Jars in Maven Repo

You can find jars in the Maven repository, by name, using:

    m2 find [-s | --suffix <stash-suffix>] [-g | --group <group>] <jar-name-pattern>

Where `suffix` is the repository suffix to be searched (or primary by default), and `group` is a dot-separated group
name pattern to search under (may be partial). The `jar-name-pattern` is a case-insensitive name matcher.

All matching jars will be listed with their group and version information.
