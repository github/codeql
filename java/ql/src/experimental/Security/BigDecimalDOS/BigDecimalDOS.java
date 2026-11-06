	@GetMapping("/tonghuaroot-DOSDemo01")
	@ResponseBody
    // BAD:
	public Long demo(@RequestParam(name = "num") BigDecimal num) {
		Long startTime = System.currentTimeMillis();
		BigDecimal num1 = new BigDecimal(0.005);
		System.out.println(num1.add(num));
		Long endTime = System.currentTimeMillis();
		Long tempTime = (endTime - startTime);
		System.out.println(tempTime);
		return tempTime;
	}

    @GetMapping("/tonghuaroot-DOSDemo02")
	@ResponseBody
    // GOOD:
	public Long demo02(@RequestParam(name = "num") String num) {
        if (num.length() > 33 || num.matches("(?i)e")) { 
            return "Input Parameter is too long."
        }
		Long startTime = System.currentTimeMillis();
		BigDecimal num1 = new BigDecimal(0.005);
		System.out.println(num1.add(num));
		Long endTime = System.currentTimeMillis();
		Long tempTime = (endTime - startTime);
		System.out.println(tempTime);
		return tempTime;
	}