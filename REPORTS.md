JSONDATA = ````
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "status": "ok",
    "address": "0x8D27dCE46e66995C4700b16E18E2Cc49721C836f",
    "current_time": {},
    "encoder_state": "available",
    "pending_tfuel": 0.841,
    "progress": 0,
    "recent_jobs": [
      {
        "is_failed": false,
        "failed_at": "",
        "create_time": "2023-10-25T11:56:46.692Z",
        "error": "",
        "type": "encoding",
        "id": "job_zvejppfc3qhc5kfn0bjqgxtqatp9",
        "reward_tfuelwei": "109000000000000000",
        "finish_time": "2023-10-25T11:57:22.385Z",
        "start_time": "2023-10-25T11:56:46.692Z"
      },
      {
        "is_failed": false,
        "failed_at": "",
        "create_time": "2023-10-25T08:43:13.938Z",
        "error": "",
        "type": "encoding",
        "id": "job_xddjd2dagtw6zg291q6tjifrwxwm",
        "reward_tfuelwei": "110000000000000000",
        "finish_time": "2023-10-25T08:43:48.795Z",
        "start_time": "2023-10-25T08:43:13.938Z"
      },
      {
        "is_failed": false,
        "failed_at": "",
        "create_time": "2023-10-24T22:33:11.724Z",
        "error": "",
        "type": "encoding",
        "id": "job_3eajp9y65hyhk6900vtp80tgfg22",
        "reward_tfuelwei": "98000000000000000",
        "finish_time": "2023-10-24T22:33:17.766Z",
        "start_time": "2023-10-24T22:33:11.724Z"
      }
    ]
  }
}
````

jq -r '(.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]] | join(",")) []' data.json

jq -r '.result.recent_jobs | (.[0] | keys_unsorted) as $keys | ($keys | join(",")), (map([.[ $keys[] ]] | join(",")) [])' input.json

(echo status; jq -r '.result.recent_jobs[].status' input.json)

echo "create_time,id,reward_tfuelwei" > output.csv && jq -r '.result.recent_jobs[] | [.create_time, .id, .reward_tfuelwei] | @csv' data.json >> output.csv

// CSV of encoding jobs
echo "create_time,id,reward_tfuelwei" ; curl -s -X POST -H 'Content-Type: application/json' --data '{"jsonrpc":"2.0","method":"edgeencoder.GetStatus","params":[],"id":1}' http://localhost:17935/rpc | jq -r '.result.recent_jobs[] | [.create_time, .id, .reward_tfuelwei] | @csv'

// Status of encoding jobs
curl -s -X POST -H 'Content-Type: application/json' --data '{"jsonrpc":"2.0","method":"edgeencoder.GetStatus","params":[],"id":1}' http://localhost:17935/rpc | jq -r '.result | .address, .encoder_state, .status, .pending_tfuel'
