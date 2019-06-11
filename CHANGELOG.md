## Version: 0.1.0 (alpha)

- Exception `RemoteAPIError` does now store the `error_code` and `error_summary` if it is available
- Adds a method to allow creation of Open Build Service projects
- Adds `exists?` method to `Projects module in order to check whether a project exists or not

## Version: 0.0.2 (alpha)

- Adds `Connection` module to establish a connection with a Build Service instance
- Adds `About` module to query information about the current Build Service instance
- Adds `Projects` module to allow searching and listing projects
- Requires a new dependency: `date` >= 2.0.0

## Version: 0.0.1 (alpha)

- Dummy release to register gem name on https://rubygems.org
