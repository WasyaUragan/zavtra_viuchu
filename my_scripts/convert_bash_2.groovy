#!/usr/bin/env groovy

HASH_COMMIT = ['chrootww', 'hash', '1.0.1', '1', '179wd71224']

HASH_COMMIT.each { i ->
    def hashCommitExist = 0
    if (i.length() != 8 && i.length() != 40) 
    {
        hashCommitExist = 1
    } 
    else 
    {
        try 
        {
            def hashCommit = "git rev-parse $i".execute().text.trim()
            println "$i is a git hash-commit."
            System.exit(0)
        } 
        catch(err) 
        {
            hashCommitExist = 1
        }
    }
}

if (hashCommitExist == 1) 
{
    println "There is no hash in this tag."
}