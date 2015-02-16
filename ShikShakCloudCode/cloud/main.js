Parse.Cloud.afterSave("ZSSShak", function(shak) {
	var deviceToken = shak.object.get("deviceToken");
	var installationQuery = new Parse.Query(Parse.Installation);
    installationQuery.equalTo("deviceToken", shak.object.get("deviceToken"));

	var isBanned = shak.object.get("isBanned");
	if (!isBanned) {
		var reportCount = shak.object.get("reportCount");
		if (reportCount >= 7) {
			shak.object.save({
			  isBanned: true,
			}, {
			  success: function(shak) {
			  	Parse.Push.send({
                        where: installationQuery,
                        data:{
                            alert: "One of your Shaks has been banned. Please follow our posting guidelines.",
                            sound: "Sup.aiff",
                            type : "message"
                            }
                        }); 
			  	// installationQuery.find({
				  // success: function(results) {
				  //   // Do something with the returned Parse.Object values
				  //   for (var i = 0; i < results.length; i++) { 
				  //     var shak = results[i];
				  //     shak.object.increment("bannedCount");
				  //     shak.object.save();
				  //   }
				  // },
				//   error: function(error) {

				//   }
				// });
			  // },
			  // error: function(shak, error) {

			  // }
			// });
		}
	}
});
