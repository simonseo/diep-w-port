angular.module('starter.controllers', ['ionic'])

.controller('PinchCtrl', function($scope, $ionicModal) {
	$scope.openModalTemplate = function(_templateName){
		if($scope.modal){
			$scope.closeModal();
		}
		var templateName = _templateName;
		$ionicModal.fromTemplateUrl("templates/" + templateName + ".html",{
			scope : $scope,
			animation : "slide-in-up"
		}).then(function(modal){
			$scope.modal = modal;
			$scope.openModal();
		});
	};

	$scope.openModal = function(){
		$scope.modal.show();
	};
	$scope.closeModal = function(){
		$scope.modal.hide();
	};
	$scope.$on('$destroy', function() {
		$scope.modal.remove();
	});
	$scope.checkAndHide = function() {
		$scope.data.bmi = $scope.bmi.value;
		$scope.modal.hide();
	};
	// Cleanup the modal when we're done with it!
	$scope.$on('$destroy', function() {
		$scope.modal.remove();
	});
	// Execute action on hide modal
	$scope.$on('modal.hidden', function() {
		// Execute action
	});
	// Execute action on remove modal
	$scope.$on('modal.removed', function() {
		// Execute action
	});

	$scope.bmiChange = function() {
		$scope.bmi.value = $scope.bmi.weight;	
		$scope.bmi.value = $scope.bmi.weight / ($scope.bmi.height*$scope.bmi.height);
		$scope.bmi.value = Number( Number($scope.bmi.value).toFixed(1) );
	}

	//$scope.rmm = "1";
	$scope.bmi = {};
	$scope.data = {
		'rmm' : '',
		'bmi' : '',
		'lmm' : '',
		'hcm' : '',
		'imm' : '',
		'wcm' : '',
		'flap' : '',
	}
	$scope.reset = function() {
		$scope.data = {
			'rmm' : '',
			'bmi' : '',
			'lmm' : '',
			'hcm' : '',
			'imm' : '',
			'wcm' : '',
			'flap' : '',
		}
	}

	$scope.calculate = function() {
		data = $scope.data;
		$scope.data.flap = ( -1308 + 24.57*Number(data.bmi)  + 6.8*(Number(data.rmm)+Number(data.lmm))/2 + 7.89*Number(data.imm) + 20.51*Number(data.hcm) + 32.55*Number(data.wcm) ).toFixed(1);
	}
})

.controller('DashCtrl', function($scope, $ionicModal) {
	$scope.openModalTemplate = function(_templateName){
		if($scope.modal){
			$scope.closeModal();
		}
		var templateName = _templateName;
		$ionicModal.fromTemplateUrl("templates/" + templateName + ".html",{
			scope : $scope,
			animation : "slide-in-up"
		}).then(function(modal){
			$scope.modal = modal;
			$scope.openModal();
		});
	};

	$scope.openModal = function(){
		$scope.modal.show();
	};
	$scope.closeModal = function(){
		$scope.modal.hide();
	};
	$scope.$on('$destroy', function() {
		$scope.modal.remove();
	});
	$scope.checkAndHide = function() {
		$scope.data.bmi = $scope.bmi.value;
		$scope.modal.hide();
	};
	// Cleanup the modal when we're done with it!
	$scope.$on('$destroy', function() {
		$scope.modal.remove();
	});
	// Execute action on hide modal
	$scope.$on('modal.hidden', function() {
		// Execute action
	});
	// Execute action on remove modal
	$scope.$on('modal.removed', function() {
		// Execute action
	});

	$scope.bmiChange = function() {
		$scope.bmi.value = $scope.bmi.weight;	
		$scope.bmi.value = $scope.bmi.weight / ($scope.bmi.height*$scope.bmi.height);
		$scope.bmi.value = Number( Number($scope.bmi.value).toFixed(1) );
	}

	//$scope.rmm = "1";
	$scope.bmi = {};
	$scope.data = {
		'rmm' : '',
		'bmi' : '',
		'lmm' : '',
		'hcm' : '',
		'imm' : '',
		'wcm' : '',
		'flap' : '',
	}
	$scope.reset = function() {
		$scope.data = {
			'rmm' : '',
			'bmi' : '',
			'lmm' : '',
			'hcm' : '',
			'imm' : '',
			'wcm' : '',
			'flap' : '',
		}
	}

	$scope.calculate = function() {
		data = $scope.data;
		$scope.data.flap = ( -435 + 11.61* Number(data.bmi) - 23.23*( Number(data.rmm)+Number(data.lmm))/2 + 8.74*Number(data.imm) + 37.72*Number(data.hcm) - 4.63*Number(data.wcm) + 1.0884*(Number(data.rmm)+Number(data.lmm))/2*Number(data.wcm) ).toFixed(1);
	}

})

.controller('AccountCtrl', function($scope) {
  $scope.settings = {
    enableFriends: true
  };
});
