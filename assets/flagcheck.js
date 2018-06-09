const data = require('./data.json')
var fs = require('fs')

const flagPath = './flags'
//console.log(data)

const output = data.map(c => {
  let flagFile =
    flagPath + '/' + c.country.toLowerCase().replace(/ /g, '-') + '.png'
  let newFlagFile = flagPath + '/' + c.isoCode.toLowerCase() + '.png'
  if (fs.existsSync(newFlagFile)) {
    // do nothing
    c.image = 'assets/flags/' + c.isoCode.toLowerCase() + '.png'
  } else if (fs.existsSync(flagFile)) {
    console.log(flagFile, 'FOUND')
    fs.rename(flagFile, newFlagFile, err => console.log)
    // Do something
  } else {
    c.image = 'assets/placeholder.png'
    console.log(flagFile, 'not found')
  }
  return c
  //console.log(c)
})

console.log(JSON.stringify(output))
