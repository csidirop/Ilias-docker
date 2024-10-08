# ILIAS Docker
This repo provides a simple and clean [docker](https://www.docker.com/) image for different [ILIAS](https://ilias.de) versions.

_All branches are WIP!_

## Docker instructions
### Select branch
There are different [branches](https://github.com/csidirop/ilias-docker/branches) that serve to provide different installations. Those provide following versions:

| **branch** | **ILIAS version** | **PHP version** | **OS** | **base image** | **last commit** |
|---|---|---|---|---|---|
| main | [release_9](https://github.com/ILIAS-eLearning/ILIAS/tree/release_9) | 8.2 | Debian 11 Bullseye | [php:8.2-apache](https://github.com/docker-library/php)  | [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/csidirop/ilias-docker/main?label=%20)](https://github.com/csidirop/ilias-docker/commits/main)  |
| [release_9](https://github.com/csidirop/ilias-docker/tree/release_9) | [release_9](https://github.com/ILIAS-eLearning/ILIAS/tree/release_9) | [8.2](https://docu.ilias.de/ilias.php?baseClass=illmpresentationgui&cmd=layout&ref_id=1719&obj_id=159944) | Debian 11 Bullseye | [php:8.2-apache](https://github.com/docker-library/php) | [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/csidirop/ilias-docker/release_9?label=%20)](https://github.com/csidirop/Ilias-docker/commits/release_9/) | |
| [release_8](https://github.com/csidirop/ilias-docker/tree/release_8) | [release_8](https://github.com/ILIAS-eLearning/ILIAS/tree/release_8) | [8.0](https://docu.ilias.de/ilias.php?baseClass=illmpresentationgui&cmd=layout&ref_id=1719&obj_id=141685) | Debian 11 Bullseye | [php:8.0-apache](https://github.com/docker-library/php) | [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/csidirop/ilias-docker/release_8?label=%20)](https://github.com/csidirop/Ilias-docker/commits/release_8/) | |
| [release_7](https://github.com/csidirop/ilias-docker/tree/release_7) | [release_7](https://github.com/ILIAS-eLearning/ILIAS/tree/release_7) | [7.x](https://docu.ilias.de/ilias.php?baseClass=illmpresentationgui&cmd=layout&ref_id=1719&obj_id=124808) | Debian 11 Bullseye | [php:7.4-apache](https://github.com/docker-library/php/blob/e4509d18e3cddd03e796dd6fd4fef88070ee5132/7.4/bullseye/apache/Dockerfile) |  [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/csidirop/ilias-docker/release_7?label=%20)](https://github.com/csidirop/Ilias-docker/commits/release_7/) |


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
