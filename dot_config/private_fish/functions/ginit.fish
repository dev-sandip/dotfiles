function ginit --description "Initialize a Go module with github.com/dev-sandip"
    if test (count $argv) -eq 0
        echo "Error: Please provide a repository name."
        echo "Usage: ginit <repo-name>"
        return 1
    end
    go mod init github.com/dev-sandip/$argv[1]
end
