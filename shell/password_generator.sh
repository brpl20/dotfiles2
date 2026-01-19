#!/bin/bash
# Strong Password Generator
# Usage: pass [length] [options]
#   length: password length (default: 20)
#   -n: no special characters
#   -a: alphanumeric only (letters and numbers)
#   -c: copy to clipboard (macOS)

LENGTH=20
CHARSET='A-Za-z0-9!@#$%^&*()_+-=[]{}|;:,.<>?'
COPY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -n)
            CHARSET='A-Za-z0-9_+-='
            shift
            ;;
        -a)
            CHARSET='A-Za-z0-9'
            shift
            ;;
        -c)
            COPY=true
            shift
            ;;
        *)
            if [[ $1 =~ ^[0-9]+$ ]]; then
                LENGTH=$1
            fi
            shift
            ;;
    esac
done

PASSWORD=$(LC_ALL=C tr -dc "$CHARSET" < /dev/urandom | head -c "$LENGTH")

if $COPY && command -v pbcopy &> /dev/null; then
    echo -n "$PASSWORD" | pbcopy
    echo "$PASSWORD (copied to clipboard)"
else
    echo "$PASSWORD"
fi
