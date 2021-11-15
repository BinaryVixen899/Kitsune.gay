

                // import fetch from "node-fetch";

                let time = Date.now()
                console.log(time)
                



                async function GetMoonPhaseData() {
                    return(
                    fetch(`https://api.farmsense.net/v1/moonphases/?d=${time}`)
                    .then(response => response.json())
                    // .then function is living in a synchronous land, created immediatelly 
                    .catch( () => console.log("this has not succeeded")))
                }
                (async function GetElement(){
                    let data = await GetMoonPhaseData();
                    let phase = data[0].Phase
                    let element = document.querySelectorAll(`[id='${phase}']`)
                    console.log(phase)
                    console.log(element)
                    element[0].style.opacity = 1
                  })();
                  
               
               
               

