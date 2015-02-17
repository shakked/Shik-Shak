Parse.Cloud.afterSave("ZSSShak", function(shak) {
	var deviceToken = shak.object.get("deviceToken");
	var installationQuery = new Parse.Query(Parse.Installation);
    installationQuery.equalTo("deviceToken", shak.object.get("deviceToken"));

    Parse.Cloud.useMasterKey();

	var isBanned = shak.object.get("isBanned");
	if (!isBanned) {
		var reportCount = shak.object.get("reportCount");
		if (reportCount >= 7) {
			shak.object.set("isBanned", true);
			shak.object.save();
			Parse.Push.send({
                where: installationQuery,
                data:{
                    alert: "One of your Shaks has been banned. Please follow our posting guidelines.",
                    sound: "Sup.aiff",
                    type : "message"
                    }
            }); 
            installationQuery.first({
				  success: function(object) {
				  		console.log("Query was successful");
				  		var bannedCount = object.get("bannedCount");
				  		console.log("Current bannedCount for installation: " + bannedCount);
				  		if (!bannedCount) {
				  			bannedCount = 1;
				  			object.set("bannedCount", bannedCount);
				  		} else {
				  			object.set("bannedCount", ++bannedCount);
				  		}
				  		console.log("BannedCount after logic: " + bannedCount);
				  		object.save();
				  },
				  error: function(error) {
				  		console.log("Query failed");
				  		console.log("Error: " + error.message);
				  }
			});

		}
	}
});


Parse.Cloud.afterSave(Parse.Installation, function(installation) {
	var bannedCount = installation.object.get("bannedCount");
	if (bannedCount >= 3) {
		installation.object.set("isBanned" , true);
		installation.object.save();

	var installationQuery = new Parse.Query(Parse.Installation);
    installationQuery.equalTo("deviceToken", installation.object.get("deviceToken"));

		Parse.Push.send({
            where: installationQuery,
            data:{
                alert: "You have been banned from Shik Shak.",
                sound: "Sup.aiff",
                type : "message"
                }
        }); 

	}
});
