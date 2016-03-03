* Start Rds and RedShift instances, Create s3 bucket
* Put export.sh to s3 bucket
* Set params in values.json
* create pipeline
```
$ aws datapipeline create-pipeline \
--name rds-copy-redshift \
--unique-id rds-copy-redshift
```
* Populate pipeline
```
$ aws datapipeline put-pipeline-definition  \
--pipeline-id  df-XYZ \
--pipeline-definition file://copy.json \
--parameter-objects  file://parameters.json  \
--parameter-values-uri file://values.json
```
* Activate pipeline
```
$ aws datapipeline activate-pipeline  \
--pipeline-id df-XYZ
```
* Show pipeline activity
```
$aws datapipeline list-runs \
--pipeline-id df-XYZ
```
