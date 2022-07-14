const functions = require("firebase-functions");
const admin = require('firebase-admin');
var convert = require('xml-js');
var svgstore = require('svgstore');
var ethers = require('ethers');

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
/*exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  //const itemIds = req.query.itemIds;
  response.setHeader('Content-Type', 'image/svg+xml');
  response.send('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 854.61 596.54"><defs><style>.cls-1{isolation:isolate;}.cls-2,.cls-3,.cls-5{fill:#fff;}.cls-2,.cls-3{stroke:#231f20;stroke-width:11.34px;}.cls-2{stroke-linecap:round;stroke-linejoin:round;}.cls-3{stroke-miterlimit:10;}.cls-4{fill:#231f20;}.cls-6{fill:#a7a9ac;mix-blend-mode:multiply;}</style></defs><g class="cls-1"><g id="HeartEyes"><path class="cls-2" d="M597.51,298.47s78.36-57.13,148.69-56.3-37.67,40.19-52.74,97.12c-9.49,35.83-10.89,93.77-56.93,93.77S588,415.48,588,415.48"/><circle class="cls-3" cx="419.5" cy="311.67" r="247.95"/><path class="cls-4" d="M617.3,164.47c-77.2-66.3-109.85,4-147.53,3.19-31-.69-110.51-87.07-200.94,22.57-18.57,22.51-32.64,49.43-44.36,108l-52.17-4.8s10-124,115-191,258-38,317,44Z"/><path class="cls-2" d="M223.3,298.47s-78.37-57.13-148.69-56.3,37.67,40.19,52.74,97.12c9.49,35.83,10.89,93.77,56.93,93.77s48.56-17.58,48.56-17.58"/><path class="cls-5" d="M378.45,367.68l12.38,84.62,12.42-81.78S394.77,364,378.45,367.68Z"/><path class="cls-2" d="M165,310c19,13.39,41.41,35.69,32.37,46.32-9.49,11.17-15.44,5.77-4.84-11.53"/><path class="cls-6" d="M60.38,244.55c3.35,8.37,75.34,50.23,85.39,79.53s8.37,87.07,35.16,88.74,46.89-10,51.91-15.9,20.09,7.53,20.93,22.6,67,127.26,202.61,115.54,185-112.19,185-112.19S573.58,556,429.58,561,214.42,451.34,214.42,451.34l-10.88-17.58s-56.09,1.67-65.3-33.49-12.56-82-27.63-92.1-59.44-53.58-59.44-53.58l-.84-9.21Z"/></g></g></svg>')
});*/


exports.signer = functions.https.onRequest(async (request, response) => {

    //Acc 0x2dE6c0dEa73D00759a5100353964E12a3893100E
    const signer = new ethers.Wallet("e39f4c63ab42edc6c881db93d5afd0e5165f4aa9101b43da49359dee1631f6c4");

    var message = "coffee and donuts"
    var messageHash = ethers.utils.solidityKeccak256(['string'], [message]);
    var signature = await signer.signMessage(ethers.utils.arrayify(messageHash));

    response.setHeader('Content-Type', 'application/json');
    response.send({"signature": signature, "hash": messageHash});
});

exports.hats = functions.https.onRequest((request, response) => {
    var jsonHat;
    var jsonHead;

    var items = ["11-01.svg", 
    "22-01.svg", "33-01.svg", "44-01.svg", "55-01.svg" , "66-01.svg", "77-01.svg", "88-01.svg", "99-01.svg"];
    var promises = [];

    items.forEach(function(element) {
        //console.log(element);
        promises.unshift(admin
            .storage()
            .bucket("crypto-suckers.appspot.com")
            .file("RGB/" + element)
            .download()
            );
        });


    Promise.all(promises).then((values) => {

        var firstkey = '>';
        var final = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 850.39 850.39">';

        values.forEach(function(element) {
            var data = element[0].toString();

            var result1 = data.substring(
                data.indexOf(firstkey) + firstkey.length, 
                data.lastIndexOf("</svg>")
            );


            final += result1;
            final = final.replace('isolation:isolate', '');

        });

        final +='</svg>';

        response.setHeader('Content-Type', 'image/svg+xml');
        response.send(final);
    });


});
