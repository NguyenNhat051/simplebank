postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

pgAdmin:
	docker run -p 80:80 \
    -e PGADMIN_DEFAULT_EMAIL="neil@gmail.com" \
    -e PGADMIN_DEFAULT_PASSWORD="admin" \
    -d dpage/pgadmin4

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path ./db/migration/ -database "postgresql://root:M2He9dSLCBQuCohbKkjt@simple-bank.crlhwasm4aqm.ap-southeast-1.rds.amazonaws.com:5432/simple_bank" -verbose up

migratedown:
	migrate -path ./db/migration/ -database "postgresql://root:M2He9dSLCBQuCohbKkjt@simple-bank.crlhwasm4aqm.ap-southeast-1.rds.amazonaws.com:5432/simple_bank" -verbose down

migrateup1:
	migrate -path ./db/migration/ -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown1:
	migrate -path ./db/migration/ -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	docker run --rm -v $(pwd):/src -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go simplebank/db/sqlc Store


.PHONY: postgres pgAdmin createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc server mock