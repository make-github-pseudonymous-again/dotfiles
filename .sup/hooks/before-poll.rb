say "Running offlineimap..."
system "offlineimap -o -u quiet > /dev/null 2>&1"
if $? != 0
  say "There was an error with offlineimap :(."
  sleep 10
end
