#Scanner, by Runway7

Scanner is a small and fast Ruby + Sinatra app (easily runs on Heroku) that can quickly scans a webpage and gives back elements based on the given CSS paths. Results are returned in JSON. 

The API takes two parameters:

`url`: The webpage you want to scan, with the protocol (`http` / `https`). URL encoded.

`path`: Comma separated list of CSS3 paths you want to extract (URL encode each path before joining them with commas). 

Examples:

http://scanner.runway7.net/?url=http://www.google.com&path=title,meta[name=%22description%22]

http://scanner.runway7.net/?url=http://www.reddit.com&path=.sitetable%20.thing%20.entry%20a.title


Designed and Crafted in India.