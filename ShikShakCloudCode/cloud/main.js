
Parse.Cloud.afterSave("ZSSShak", function(shak) {
	var isBanned = shak.get("isBanned");
	if (!isBanned) {
		var reportCount = shak.get("reportCount");
		if (reportCount >= 7) {
			shak.set("isBanned", true);
			shak.save({
				isBanned : true
			}, {
				success: function(shak) {
					//saved
				},
				error: function(shak, error) {
					//save failed
				}
			});
		}
	}

}
