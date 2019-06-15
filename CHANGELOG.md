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
