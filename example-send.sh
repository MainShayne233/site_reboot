curl -s \
-X POST \
--user "bb49446947c44fd35709c2c069aa6279:528e5056005043fc4c6bc5522facce9f" \
https://api.mailjet.com/v3.1/send \
-H 'Content-Type: application/json' \
-d '{
  "Messages":[
    {
      "From": {
        "Email": "shaynetremblay@gmail.com",
        "Name": "Shayne"
      },
      "To": [
        {
          "Email": "shaynetremblay@gmail.com",
          "Name": "Shayne"
        }
      ],
      "Subject": "Test",
      "TextPart": "TextPart.",
      "CustomID": "ID"
    }
  ]
}'
