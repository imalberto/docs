
Example of how yuidocs should be used.

Links to the generated docs:

- [link
  1](https://rawgithub.com/imalberto/docs/master/yuidocs/apidocs/index.html)
- [link
  2](http://htmlpreview.github.io/?http://github.com/imalberto/docs/blob/master/yuidocs/apidocs/index.html)

## Instructions

To create the docs:

    make 

    OR

    npm run doc

    OR

    yuidoc --config ./yuidoc.json .

To serve the api docs locally on port 5000:

    yuidocs --serve 5000 .
