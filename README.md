# Docker MySQL migration image

This image will automatically play a sequence of SQL scripts against an existing MySQL database. It's useful as part of a compose file to keep the schema up to date without having to delete the MySQL volume to update the schema.

# Usage

Run the image setting the following environment variables:

 * `MYSQL_HOST`
 * `MYSQL_USER`
 * `MYSQL_PASSWORD`
 * `MYSQL_DATABASE`
 
 Ensure your database container is running and link it to the container (`-l`)
 
 Finally, map your directory containing migrations to `/docker-entrypoint-migrations.d`. Each migration should be an `sql` or `sql.gz` file and must start with `migration`.
 
# Example (standalone)

	docker run --link=database \
		-e MYSQL_HOST=database \
		-e MYSQL_USER=user \
		-e MYSQL_PASSWORD=password \
		-e MYSQL_DATABASE=db \
		-v $(pwd)/migrations:/docker-entrypoint-migrations.d/ \
		mathewhall/mysql_migration 

# Example (compose)

	database:
	  image: mysql
	  expose:
	    - 3306
	  volumes:
	    - ./schema:/docker-entrypoint-initdb.d
	    - /var/lib/mysql
	  environment:
	    MYSQL_DATABASE: database
	    MYSQL_USER: user
	    MYSQL_PASSWORD: password
	    MYSQL_ROOT_PASSWORD: root_password
  
	migration:
	  image: mathewhall/mysql_migration
	  volumes:
	    - ./migrations:/docker-entrypoint-migrations.d
	  links:
	    - database
	  environment:
	    MYSQL_HOST: database
	    MYSQL_DATABASE: database
	    MYSQL_USER: user
	    MYSQL_PASSWORD: password

Each time your containers are started via compose, the migrations will run. You can avoid repeating the environment variables using the `env_file` directive in your compose file to define the MySQL credentials in one place instead of two.