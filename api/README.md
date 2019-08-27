# NoSlice API


## Installation for development

```bash
# Copy and update configurations
cp .env.dist .env

# Start project
docker-compose up -d --build

# Install dependencies
docker-compose exec app mix deps.get

# Initialize database
docker-compose exec app mix ecto.migrate
```
