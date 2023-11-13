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

$ ps aux | grep lavita
root         109  0.0  0.0   4492  3432 ?        S    Oct25   0:00 /bin/bash /usr/bin/launch-lavita.sh start . 8 0

// FedML Jobs
curl -s -X POST http://localhost:40800/fedml/api/v2/historyJobStatus -d "{}" | jq '.'

// Lavita Jobs
curl -s -X GET 'http://localhost:12888/past_jobs?page=0&num=10' | jq '.'

cd /root/fedml-miniconda/envs/fedml-theta-pip/bin/ 
./fedml --help
Commands:
  login     Login the FedML® Nexus AI Platform
  logout    Logout from the FedML® Nexus AI Platform
  launch    Launch job at the FedML® Nexus AI platform
  cluster   Manage clusters on FedML® Nexus AI Platform
  run       Manage runs on the FedML® Nexus AI Platform.
  device    Bind/unbind devices to the FedML® Nexus AI Platform
  model     FedML Model CLI will help you manage the model cards, whether...
  build     Build packages for the FedML® Nexus AI Platform
  logs      Display logs for ongoing runs
  train     Manage training resources on FedML® Nexus AI Platform
  federate  Manage federated learning resources on FedML® Nexus AI Platform
  env       Get environment info such as versions, hardware, and networking
  network   Check the Nexus AI backend network connectivity
  version   Display FEDML library version
(

$ ./fedml env

======== FedML (https://fedml.ai) ========
FedML version: 0.8.11.post4
FedML ENV version: release
Execution path:/root/fedml-miniconda/envs/fedml-theta-pip/lib/python3.8/site-packages/fedml/__init__.py

======== Running Environment ========
OS: Linux-6.1.0-0.deb11.7-amd64-x86_64-with-glibc2.17
Hardware: x86_64
Python version: 3.8.17 (default, Jul  5 2023, 21:04:15) 
[GCC 11.2.0]
PyTorch version: 2.0.1+cu117
MPI4py is NOT installed

======== CPU Configuration ========
The CPU usage is : 17%
Available CPU Memory: 17.0 G / 31.22247314453125G

======== GPU Configuration ========
No GPU devices

======== Network Connection Checking ========
The connection to https://open.fedml.ai is OK.

The connection to S3 Object Storage is OK.

The connection to mqtt.fedml.ai (port:1883) is OK.
