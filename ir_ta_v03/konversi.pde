int stoi(String x){
  int n;
  char carray[6]; //converting string to number
  x.toCharArray(carray, sizeof(carray));
  n = atoi(carray); 
  return n;
}

