HOST=$1
DATABASE=$2
USER=$3
PGPASSWORD=$4
PORT=$5
TABLE=$6
START=$7
STOP=$8
sudo yum install postgresql -yq >> /dev/null

export PGPASSWORD=$PGPASSWORD
psql -h ${HOST}  -p ${PORT} -U ${USER} ${DATABASE} -c "COPY (select * from ${TABLE}   order by id offset ${START}  limit ${STOP} )   to stdout with  CSV "
