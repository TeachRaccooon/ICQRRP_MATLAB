ipiv = [3, 5, 5];

m = 5;
mn = 3;

perm = 1:m;
for i = 1:mn
    tmp_int = perm(1, ipiv(1, i) - 1);
    perm(1, ipiv(i) - 1) = perm(1, i);
    perm(1, i) = tmp_int;
end

perm
