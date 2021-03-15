#include <iostream>
#include <list>
using namespace std;

int main() {
    int low = 0, high = 10, i;
    bool isPrime = true;
    list<int> mylist;
    list<int>::iterator it;

    // cout << "Enter two numbers (intervals): ";
    // cin >> low >> high;
    // cout << "\nPrime numbers between " << low << " and " << high << " are: " << endl;

    // set some initial values:
    for (int i = 1; i <= high; ++i) mylist.push_back(0);
    it = mylist.begin();
    while (low < high) {
        isPrime = true;
        if (low == 0 || low == 1) {
            isPrime = false;
        }
        else {
            for (i = 2; i <= low / 2; ++i) {
                if (low % i == 0) {
                    isPrime = false;
                    break;
                }
            }
        }

        if (isPrime) {
            printf("%d\n", low);
            mylist.insert(it, low);
        }
  
        ++low;
    }

    cout << "mylist contains:";
    for (it = mylist.begin(); it != mylist.end(); ++it)
        cout << ' ' << *it;
    cout << '\n';

    return 0;
}