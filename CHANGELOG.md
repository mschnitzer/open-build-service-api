## Version: 0.3.0 (alpha)

- Added `#rebuild_failed!` method to `Package` model to rebuild only failed builds

## Version: 0.2.0 (alpha)

- Added `#public_key` method to `Project` model to retrieve a project's public key
- Added `#delete!` method to `Package` model to allow deletion of packages
- Added 'Collections' system to act on a dataset like an Array and use API methods as well
- Added `#rebuild!` method to `Package` model to allow rebuilding of packages
- Added `#meta` method to `Project` model to obtain a project's meta config file
- Added `#meta` method to `Package` model to obtain the meta definition of a package
- Added `#reload!` method to `Package` model to reload the cached data of a package
- Added `#title` method to `Package` model to obtain the title of a package
- Added `#description` method to `Package` model to obtain the description of a package
- Improve output of `#inspect` for `Package` model instances

## Version: 0.1.0 (alpha)

- Exception `RemoteAPIError` does now store the `error_code` and `error_summary` if it is available
- Added a method to allow creation of Open Build Service projects
- Added `exists?` method to `Projects module in order to check whether a project exists or not
- Added a `branch_package` method to Project model to allow branching of source packages
- Added a `delete!` method to Project model to allow deletion of source projects

## Version: 0.0.2 (alpha)

- Adds `Connection` module to establish a connection with a Build Service instance
- Adds `About` module to query information about the current Build Service instance
- Adds `Projects` module to allow searching and listing projects
- Requires a new dependency: `date` >= 2.0.0

## Version: 0.0.1 (alpha)

- Dummy release to register gem name on https://rubygems.org
