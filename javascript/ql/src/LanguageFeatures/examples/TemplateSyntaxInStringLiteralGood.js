log.info(`Connecting to ${id}`)
let connection = openConnection(id)
if (!connection) {
  log.error(`Could not connect to ${id}`)
}
