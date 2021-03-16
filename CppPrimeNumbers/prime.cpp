#include <iostream>
#include <list>
#include <chrono> 
using namespace std::chrono;
using namespace std;

int main() {
    auto start = high_resolution_clock::now();
    int low = 0, high = 10, i;
    bool isPrime = true;
    list<int> mylist;
    list<int>::iterator it;

    it = mylist.begin();


    for (int low = 0; low < 30; low++) {

        std::cout << 'it1' << low;
        std::cout << '\n';

        if (low <= 1) {
            isPrime = false;
            continue;
        }
        else if (low == 3) {
            isPrime = true;
            mylist.insert(it, low);
            continue;
        }
        else if(low % 2 == 0 or low % 3 == 0) {
            isPrime = false;
            continue;
        }

        int iy = 5;

        for (int ii = iy; ii*ii <= low; ii++) {
            std::cout << 'it2' << ii;
            std::cout << '\n';

            if (low % ii == 0 or low % (ii + 2) == 0) {
                isPrime = false;
                continue;
            }
            ii = ii + 6;
        }
        isPrime = true;
        mylist.insert(it, low);

    }

    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<seconds>(stop - start);

    std::cout << "Time taken by function: "
        << duration.count() << " seconds" << endl;

    std::cout << "cpp list: ";
    for (it = mylist.begin(); it != mylist.end(); ++it) {
        std::cout << ' ' << *it;
        std::cout << '\n';
    }

    return 0;
}