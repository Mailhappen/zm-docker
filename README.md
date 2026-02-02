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

## Maintenance Mode

Maintenance mode allow us to stop the container during startup process so that we can manually perform tasks such as migration.

To start container in maintenance mode, use `docker compose -f compose.yaml -f maintenance.yaml up -d`. To see the status, type `docker compose logs`.

## Update to new version

If there is new zimbra image released, edit `config.txt` to change the `VERSION` and type `docker compose build` to create a new one container. And then `docker compose up -d`.

## What's next

Need help? Go to https://github.com/mailhappen/zm-docker to open issue and we try to assist you.

Enjoy running zimbra container!
