function unitTests()
% unit tests for ex5

polyFeaturesTests();

end



function polyFeaturesTests()
	testcases = { ...
		{[1 ; 2; 3], 2, [1 1 ; 2 4; 3 9]  } ...
		{[1 ; 2; 3], 3, [1 1 1; 2 4 8; 3 9 27]  } ...
		{[1 ; 3]   , 5, [1 1 1 1 1; 3 9 27 81 243] } ...
		} ;
	for i = 1:size(testcases,2);
		inputFeatures= testcases{i}{1}; 
		inputDegree= testcases{i}{2};
		expectedOutput= testcases{i}{3};
		result= polyFeatures(inputFeatures, inputDegree);

		result==expectedOutput || ...
			error( sprintf('result %i wrong', i, display(expectedOutput), display(result)));
	end

endfunction

