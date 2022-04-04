### The good, bad & ugly to look out for
- Never commit ssh keys & other aws, azure, gcloud keys as part of the docker image (wipe things out from the live image of such sort if there's any).
- Scan Sarathy images for vulnerabilities and keep them to minimal.
- Make sure all the open source tools being added in Sarathy's toolchain are properly vetted/examined.
- For all the open source tools we are using, disable telementary or any other kind of tracking to collect user data/stats etc.
- Use wireguard etc to keep an eye on Sarathy's network activity to ensure no tools are tracking