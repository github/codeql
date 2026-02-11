extern "C" {
int main1(int argc, char** argv);
int main3(int argc, char** argv);
}
int main4(int argc, char** argv);

int main(int argc, char** argv) {
    main1(argc, argv);
    main3(argc, argv);
    main4(argc, argv);
    return 0;
}
