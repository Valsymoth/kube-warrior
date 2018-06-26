# kube-warrior

A lazy, non-terraformish way of bootstrapping K8 cluster on Digital ocean.
Not intended for production use. 

I feel that his should be documented.

```
curl -X GET --silent "https://api.digitalocean.com/v2/images?per_page=999" -H "Authorization: Bearer $DO_API_TOKEN"
```
