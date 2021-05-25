function CheckAddProduct() {
	
		function checkUpdateReservation() {
		
		var regExpName = /^[a-zA-Z가-힣]*$/;
		var regExpNum = /^[0-9]*$/;
		var regExpDate = /^\d{4}-\d{2}-\d{2}$/;
		var regExpTime = /^\d{2}:\d{2}:\d{2}$/;
		var form = document.updateReservation;
		
		var name = document.updateReservation.name.value;
		var phoneNumber = document.updateReservation.phoneNumber.value;
		var date = document.updateReservation.date.value;
		var time = document.updateReservation.time.value;
		var covers = document.updateReservation.covers.value;
		
		if(!regExpName.test(name)){
			alert("이름은 알파벳, 한글만 입력해주세요!");
			form.name.select();
			return;
		}
		if(!regExpNum.test(phoneNumber)){
			alert("전화번호는 숫자만 입력해주세요!")
			return;
		}
		if(!regExpDate.test(date)){
			alert("날짜는 YYYY-MM-DD 형식으로 입력해주세요!");
			return;
		}
		if(!regExpTime.test(time)){
			alert("시간은 HH-MM-SS 형식으로 입력해주세요!");
			return;
		}
		if(!regExpNum.test(covers)){
			alert("인원은 숫자만 입력해주세요!");
			return;
		}
		
		document.updateReservation.submit();
		
	}
}