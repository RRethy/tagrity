# TODO

* Better error handling
* Delete old tags before doing --append (similar to ripper-tags funtionality, but do it for all ctags-alikes)
* Restart process which were terminated due to a system shutdown
    * Will have to add `tagrity stop <pid>` instead of forcing users to use `kill <pid>`
* Watch local and global config for changes and reload automatically
* Better --fresh for git repos
