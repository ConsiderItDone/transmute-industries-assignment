var config = require('config');
var YoutubeViews = artifacts.require("./YoutubeViews.sol");


contract('YoutubeViews', function (accounts) {
    it("should fetch Youtube view count", function () {

        //deploy contract
        return YoutubeViews.deployed().then(function (contract) {
            var events = contract.allEvents();

            return new Promise(
                function (resolve, reject) {
                    //subscribe to events
                    events.watch(function (error, event) {
                        resolve(event);
                    });
                });
        }).then(function (event) {
            //check event is ours
            if (event.event === "ChangeCount") {
                var viewCount = event.args._value.toNumber();

                console.log(viewCount)

                assert.equal(viewCount, 2942303145, "View count is different");

            }

        });//.then(done);

        // return YoutubeViews.deployed().then(function (contract) {
        //
        //     //var events = contract.allEvents();
        //     var event = contract.ChangeCount({fromBlock: 0});
        //
        //     // event.get(function(someData) {
        //     //
        //     // });
        //
        //     return new Promise(
        //         function (resolve, reject) {
        //             event.get(function (error, log) {
        //                 resolve(log, done);
        //             });
        //         });
        //
        //     //return contract.viewsCount.call();
        // }).then(function (events) {
        //     console.log(events);
        //     // assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
        // });
    });
});