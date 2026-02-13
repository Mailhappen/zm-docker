# zm-docker

This deploy Zimbra as standalone single server.

## How to use

1. Clone this repository and rename it the folder to your project name.
2. Modify `config.txt` for your environment.
3. Type `docker compose up -d` to start it up. Then `docker compose logs -f` to view the startup progress.
4. Use `docker compose exec zimbra bash` to login into the container. To exit from the container, type `exit`.
5. To stop the container, type `docker compose stop`; to start again, type `docker compose start`.
6. To destroy the container, type `docker compose down`. Your data will be retained. Refer to Step 3 to start again.
7. To destroy everything, type `docker compose down -v`. This remove container AND the volume data. **USE WITH CAUTION!**

### Example to run Zimbra docker
```
git clone https://github.com/Mailhappen/zm-docker.git
mv zm-docker mail.example.test
cd mail.example.test
vi config.txt
docker compose up -d
docker compose logs -f
```

## Maintenance Mode

Maintenance mode allow us to stop the container during startup process so that we can manually perform tasks such as migration.

To start container in maintenance mode,

```
docker compose -f compose.yaml -f maintenance.yaml up -d
docker compose exec zimbra bash
```

While inside the container, do your work. Once completed, you can start up Zimbra as usual to test the startup.

```
unset MAINTENANCE
/etc/supervisor/zimbra.sh
```

We often use this procedure to test migration and upgrade.

## ObjectStorage Support using JuiceFS

We can keep our store and backup in the external S3 ObjectStorage. We use JuiceFS storage driver. Edit `config.txt` to define `BUCKET`, `ACCESS_KEY`, `SECRET_KEY` and `VOLUME_PREFIX`.

Here is how to run it,

```
docker plugin install juicedata/juicefs:1.3.1
docker compose -f compose.yaml -f juicefs.yaml up -d
```

## Update to new version

If there is new zimbra image released, edit `config.txt` to change the `VERSION` and type `docker compose build` to create a new one container. And then `docker compose up -d`.

### Example to upgrade

```
cd mail.example.test
vi config.txt
docker compose build
docker compose up -d
```

## What's next

Need help? Go to https://github.com/mailhappen/zm-docker to open issue and we try to assist you.

Enjoy running zimbra container!
