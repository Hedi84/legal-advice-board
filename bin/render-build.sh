set -o errexit

echo "RAILS_ENV=$RAILS_ENV"
echo "RAILS_MASTER_KEY length: ${#RAILS_MASTER_KEY}"
echo "SECRET_KEY_BASE length: ${#SECRET_KEY_BASE}"
echo "DATABASE_URL present? ${DATABASE_URL:+yes}"

bundle install
RAILS_ENV=production bin/rails assets:precompile
RAILS_ENV=production bin/rails assets:clean
RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails db:seed