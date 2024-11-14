# ILIAS Docker
This repo provides a simple and clean [docker](https://www.docker.com/) image for different [ILIAS](https://ilias.de) versions.

_All branches are WIP!_

## Docker instructions
### Select branch
There are different [branches](https://github.com/csidirop/ilias-docker/branches) that serve to provide different installations. Those provide following versions:

| **branch** | **ILIAS version** | **PHP version** | **OS** | **base image** | **last commit** |
|---|---|---|---|---|---|
| [main](https://github.com/csidirop/ilias-docker) | [release_10](https://github.com/ILIAS-eLearning/ILIAS/tree/release_10) | [8.3](https://www.php.net/ChangeLog-8.php#PHP_8_3) | Debian 11 Bullseye | [php:8.3-apache](https://github.com/docker-library/php)  | [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/csidirop/ilias-docker/main?label=%20)](https://github.com/csidirop/ilias-docker/commits/main)  |
| release_10° | [release_10](https://github.com/ILIAS-eLearning/ILIAS/tree/release_10) | [8.3](https://www.php.net/ChangeLog-8.php#PHP_8_3) | Debian 11 Bullseye | [php:8.3-apache](https://github.com/docker-library/php)  | [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/csidirop/ilias-docker/main?label=%20)](https://github.com/csidirop/ilias-docker/commits/main) <!-- TODO: change to release_10 branch once released and created!! --> |
| [release_9](https://github.com/csidirop/ilias-docker/tree/release_9) | [release_9](https://github.com/ILIAS-eLearning/ILIAS/tree/release_9) | [8.2](https://www.php.net/ChangeLog-8.php#PHP_8_2) | Debian 11 Bullseye | [php:8.2-apache](https://github.com/docker-library/php) | [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/csidirop/ilias-docker/release_9?label=%20)](https://github.com/csidirop/Ilias-docker/commits/release_9/) | |
| [release_8](https://github.com/csidirop/ilias-docker/tree/release_8) | [release_8](https://github.com/ILIAS-eLearning/ILIAS/tree/release_8) | [8.0](https://www.php.net/ChangeLog-8.php#PHP_8_0) | Debian 11 Bullseye | [php:8.0-apache](https://github.com/docker-library/php) | [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/csidirop/ilias-docker/release_8?label=%20)](https://github.com/csidirop/Ilias-docker/commits/release_8/) | |
| [release_7](https://github.com/csidirop/ilias-docker/tree/release_7) | [release_7](https://github.com/ILIAS-eLearning/ILIAS/tree/release_7) [(7.30)](https://github.com/ILIAS-eLearning/ILIAS/releases/v7.30/)* | [7.4](https://www.php.net/ChangeLog-7.php#PHP_7_4) | Debian 11 Bullseye | [php:7.4-apache](https://github.com/docker-library/php/blob/e4509d18e3cddd03e796dd6fd4fef88070ee5132/7.4/bullseye/apache/Dockerfile) |  [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/csidirop/ilias-docker/release_7?label=%20)](https://github.com/csidirop/Ilias-docker/commits/release_7/) |

_°WIP!_   
_[*ILIAS dropped support for release_7 few months after release 7.30 has been published on May 14, 2024](https://docu.ilias.de/ilias.php?baseClass=illmpresentationgui&cmd=layout&ref_id=35&obj_id=124807&obj_type=StructureObject)_

<!-- Table created with: https://www.tablesgenerator.com/markdown_tables -->

### Setup
#### Clone this repo:
    git clone https://github.com/csidirop/ilias-docker/

#### Checkout Branch:
    git checkout <branchname>

#### Run images:
    docker compose up

or

    docker-compose up

#### OR to just build the images:
    docker build -t <anyname> --no-cache

### Ilias ready to go:
-> http://localhost/

Initial Credentials:
 - user: `root`
 - PW: `homer`


## Some Paths

#### Plugins:
  - `Customizing/global/plugins/Services/Repository/RepositoryObject/<PluginName>`

#### Plugin Data:
  - `data/<ILIASTITLE>/<LibName>/`
  - eg.:
    - `data/<ILIASTITLE>/<LibName>/libraries/H5P.<LibName-version>/`
