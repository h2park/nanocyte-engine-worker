EngineInputNode = require '@octoblu/nanocyte-engine-simple/src/models/engine-input-node'

class QueueWorker
  constructor: ({@client,@timeout}) ->

  run: (callback) =>
    @client.brpop 'request:queue', @timeout, (error,result) =>
      return callback error if error?
      return callback() unless result?

      [queueName, request] = result

      engineInput = new EngineInputNode
      inputStream = engineInput.message request

      inputStream.on 'finish', callback
      inputStream.on 'error', callback

module.exports = QueueWorker
