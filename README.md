# FORESTER
_Concept by Evgeny Mavrodiev_  
_Scripts by [github.com/dellch](https://github.com/dellch)_  
_Paper available at PeerJ: [A laid-back trip through the Hennigian Forests](https://peerj.com/articles/3578/)_

### Description
FORESTER version 1.0

Trees.rb represents a conventional binary matrix as an array of the Newick trees

Seedlings.rb represents a 3TS matrix as an array of the Newick trees

### Requirements
[ruby](https://www.ruby-lang.org/en/) (developed with ruby 2.3)
## Scripts
### trees.rb ([github](https://github.com/dellch/forester/blob/master/trees.rb) | [download](https://raw.githubusercontent.com/dellch/forester/master/trees.rb))

#### Usage
```
ruby trees.rb NAME_OF_FILE
```
#### Outputs
trees.rb outputs three files: 
 * NO_POLY_original-filename.txt
 * WITH_POLY_original-filename.txt
 * ADDITIONAL_FILE_original-filename.txt

### seedlings.rb ([github](https://github.com/dellch/forester/blob/master/seedlings.rb) | [download](https://raw.githubusercontent.com/dellch/forester/master/seedlings.rb))

#### Usage
```
ruby seedlings.rb NAME_OF_FILE
```
#### Outputs
seedlings.rb outputs one file: 
 * altered_original-filename.txt
