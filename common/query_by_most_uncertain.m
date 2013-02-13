function query_ind = query_by_most_uncertain(f, training_set_indicator)
%%
%
%%
all_inx = 1:length(training_set_indicator);
test_inx = all_inx(training_set_indicator==0);
[foo_val ind_in_test] = min(abs(f(test_inx)));
query_ind = test_inx( ind_in_test(1) );         
