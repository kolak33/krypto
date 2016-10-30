#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/applink.c>
#include <openssl/buffer.h>
#include <string.h>
#include <stdio.h>
#include <openssl/bio.h>
#include <openssl/evp.h>
#include <stdint.h>
#include <assert.h>
#include <windows.h>




size_t calcDecodeLength(const char* b64input) { //Calculates the length of a decoded string
    size_t len = strlen(b64input),
        padding = 0;

    if (b64input[len-1] == '=' && b64input[len-2] == '=') //last two chars are =
        padding = 2;
    else if (b64input[len-1] == '=') //last char is =
        padding = 1;

    return (len*3)/4 - padding;
}

int Base64Decode(char* b64message, unsigned char** buffer, size_t* length) { //Decodes a base64 encoded string
    BIO *bio, *b64;

    int decodeLen = calcDecodeLength(b64message);
    *buffer = (unsigned char*)malloc(decodeLen + 1);
    (*buffer)[decodeLen] = '\0';

    bio = BIO_new_mem_buf(b64message, -1);
    b64 = BIO_new(BIO_f_base64());
    bio = BIO_push(b64, bio);

    BIO_set_flags(bio, BIO_FLAGS_BASE64_NO_NL); //Do not use newlines to flush buffer
    *length = BIO_read(bio, *buffer, strlen(b64message));
    assert(*length == decodeLen); //length should equal decodeLen, else something went horribly wrong
    BIO_free_all(bio);

    return (0); //success
}

int Base64Encode(const unsigned char* buffer, size_t length, char** b64text) { //Encodes a binary safe base 64 string
    BIO *bio, *b64;
    BUF_MEM *bufferPtr;

    b64 = BIO_new(BIO_f_base64());
    bio = BIO_new(BIO_s_mem());
    bio = BIO_push(b64, bio);

    BIO_set_flags(bio, BIO_FLAGS_BASE64_NO_NL); //Ignore newlines - write everything in one line
    BIO_write(bio, buffer, length);
    BIO_flush(bio);
    BIO_get_mem_ptr(bio, &bufferPtr);
    BIO_set_close(bio, BIO_NOCLOSE);
    BIO_free_all(bio);

    *b64text=(*bufferPtr).data;

    return (0); //success
}

int encrypt(unsigned char *plaintext, int plaintext_len, unsigned char *key,
  unsigned char *iv, unsigned char *ciphertext)
{
  EVP_CIPHER_CTX *ctx;

  int len;

  int ciphertext_len;

  /* Create and initialise the context */
  if(!(ctx = EVP_CIPHER_CTX_new())) handleErrors();

  /* Initialise the encryption operation. IMPORTANT - ensure you use a key
   * and IV size appropriate for your cipher
   * In this example we are using 256 bit AES (i.e. a 256 bit key). The
   * IV size for *most* modes is the same as the block size. For AES this
   * is 128 bits */
  if(1 != EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv))
    handleErrors();


  /* Provide the message to be encrypted, and obtain the encrypted output.
   * EVP_EncryptUpdate can be called multiple times if necessary
   */
  if(1 != EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len))
    handleErrors();
  ciphertext_len = len;

  /* Finalise the encryption. Further ciphertext bytes may be written at
   * this stage.
   */
  if(1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len)) handleErrors();
  ciphertext_len += len;

  /* Clean up */
  EVP_CIPHER_CTX_free(ctx);

  return ciphertext_len;
}

int decrypt(unsigned char *ciphertext, int ciphertext_len, unsigned char *key,
  unsigned char *iv, unsigned char *plaintext)
{
  EVP_CIPHER_CTX *ctx;

  int len;

  int plaintext_len;

  /* Create and initialise the context */
  if(!(ctx = EVP_CIPHER_CTX_new())) handleErrors();


  /* Initialise the decryption operation. IMPORTANT - ensure you use a key
   * and IV size appropriate for your cipher
   * In this example we are using 256 bit AES (i.e. a 256 bit key). The
   * IV size for *most* modes is the same as the block size. For AES this
   * is 128 bits */
  if(1 != EVP_DecryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv))
    handleErrors();
    EVP_CIPHER_CTX_set_padding(ctx, 0);



  /* Provide the message to be decrypted, and obtain the plaintext output.
   * EVP_DecryptUpdate can be called multiple times if necessary
   */
  if(1 != EVP_DecryptUpdate(ctx, plaintext, &len, ciphertext, ciphertext_len))
    handleErrors();
  plaintext_len = len;

  /* Finalise the decryption. Further plaintext bytes may be written at
   * this stage.
   */
  if(1 != EVP_DecryptFinal_ex(ctx, plaintext + len, &len)) handleErrors();
  plaintext_len += len;

  /* Clean up */
  EVP_CIPHER_CTX_free(ctx);

  return plaintext_len;
}

void handleErrors(void)
{
  ERR_print_errors_fp(stderr);
  abort();
}

typedef struct Przekaz
{
    unsigned char *iv;
    unsigned char *krypt64dec;
    unsigned char *klucz;
    int krypt64declen;
    int th_number;
    int th_max;
} Przek;


float verify(unsigned char *decryptedtext, int decryptedtext_len)
{

    int id, value, nextval;
    int litery = 0;


    for(id = 0; id < decryptedtext_len; ++id)
    {
        value = (int)decryptedtext[id];
        if( (value >= 32 && value <= 126) ) // akceptowalny kod ASCII
        {
            ++litery;
        }
        else if( (value >= 195 && value <= 197) ) // mozliwe ze polski znak, sprawdzam kolejny bajt
        {
            //jezeli nie ma kolejnego bajtu
            if(id == decryptedtext_len - 1) break;
            else // jezeli jest, to sprawdz czy to jeden z polskich znakow
            {
                ++id; // zwiekszamy licznik znaku
                nextval = (int)decryptedtext[id];
                switch(value)
                {
                 case 196:
                    if( (nextval >= 132 && nextval <= 135) || nextval == 152 || nextval == 153) litery += 2; continue;
                    break;
                 case 197:
                    if( (nextval >= 129 && nextval <= 132) || (nextval >= 185 && nextval <= 188) || nextval == 154 || nextval == 155) litery += 2; continue;
                    break;
                 case 195:
                    if( nextval == 147 || nextval == 179 ) litery += 2; continue;
                    break;
                default:
                    break;
                }

            }
        }
        // else jakis lipny znak
    }

    return ( (float)litery / (float)decryptedtext_len);
}

DWORD WINAPI ThreadFunc(void* inic_struct) {


    Przek *s = (Przek *) inic_struct;
    unsigned char decryptedtext[512];
    int decryptedtext_len;


    int key_len = 32; //bajty
    int block_size = 16;

    unsigned char decode_first[block_size];
    unsigned char klucz_th[key_len];


    memcpy ( klucz_th, s->klucz, 32 );
    memcpy ( decode_first, s->krypt64dec, 16 );


    int i0, i1, i2, i3, i4;
    int minelo = 0;
    float ver;

    int start = 256 / s->th_max; // 256/8 = 32

    //printf("Rozpoczeto szukanie kluczy.\n");
    for(i0 = s->th_number * start; i0 < s->th_number * start + start; ++i0)
    {
        if(i0 % (4) == 0)
        {
            printf("Watek nr %d: Sprawdzono %d/8 kluczy.\n",s->th_number, minelo);
            ++minelo;
        }

        klucz_th[0] = (unsigned char) i0;
        for(i1 = 0; i1 <= 255; ++i1)
        {
            klucz_th[1] = (unsigned char) i1;
            for(i2 = 0; i2 <= 255; ++i2)
            {
                klucz_th[2] = (unsigned char) i2;
                for(i3 = 0; i3 <= 255; ++i3)
                {

                    klucz_th[3] = (unsigned char) i3;


                        // Decrypt the ciphertext, 16 byte block first, then additional decrypt if needed

                        decryptedtext_len = decrypt(decode_first, block_size, klucz_th, s->iv, decryptedtext);
                        // teraz sprawdzic jaka czesc tekstu okazala sie poprawna
                        ver = verify(decryptedtext, decryptedtext_len);

                        if(ver > 0.8) // teraz testujemy dalej odszyfrowujac reszte
                        {
                            decryptedtext_len = decrypt(s->krypt64dec, s->krypt64declen, klucz_th, s->iv, decryptedtext); //moze wstawic kod funkcji bezposrednio
                            ver = verify(decryptedtext, decryptedtext_len);

                            if(ver > 0.7)
                            {
                                decryptedtext[decryptedtext_len] = '\0';
                                printf("Decrypted text is:\n");
                                printf("%s\n", decryptedtext);
                                printf("Its Key Values are:\n");
                                printf("%d %d %d %d %d %d %d %d\n", (int)klucz_th[0], (int)klucz_th[1], (int)klucz_th[2], (int)klucz_th[3], (int)klucz_th[4], (int)klucz_th[5],
                                         (int)klucz_th[6], (int)klucz_th[7]);
                            }
                        }


                 }
             }
         }
     }


  return 0;
}

int main (int argc, char **argv)
{
  /* Set up the key and iv. Do I need to say to not hard code these in a
   * real application? :-)
   */

  /* A 256 bit key */
  unsigned char *key = (unsigned char *)"00000000ad2d1d33ac3fd32fcec4038c275792a1294553d07165f8040030a717"; // 4a16a06503fc268e94e01b2db2ff7905f473e7282749f12817a6a7be92f73742

  int i;
  unsigned char realKey[32];
  char tmp[3] = { 0 };
  for(i = 0; i < 32; i++)
  {
      memcpy(tmp, key + 2 * i, 2);
      realKey[i] = (unsigned char)strtol(tmp, NULL, 16);
  }



  /* A 128 bit IV */
  unsigned char *iv = (unsigned char *)"45e85942862382751070390ae1bf11a6"; // a6263af6c5bd6b5e26b7beddb3cd6ab4


  unsigned char realiv[16];
  char tmp2[3] = { 0 };
  for(i = 0; i < 16; i++)
  {
      memcpy(tmp2, iv + 2 * i, 2);
      realiv[i] = (unsigned char)strtol(tmp2, NULL, 16);
  }


  char *newkryptogram = "Vnfuw/CObrBjNVmBFyeZm0Mk/HPYQKrpg72VcTRWchoI9p6Gackp4ikcSdzQfOx+lZe2J4gQlEv0bqplX2TU3jr8tG0GlVTYueaIeHr4Ktc2AK2L+trUSu/NugYNgckYwmIAazPNpKml9M9WC2QrZDjZ8ikj7+7H6sPgVfWLAzOWkM2P6coCJq2jIx4yIqnX";
  // nie potrzeba castowania (char *) przy string literałach


  unsigned char* krypto64decoded;
  size_t krypto64decoded_len; // albo size_t i potem bez casta


  /* Initialise the library */
  ERR_load_crypto_strings();
  OpenSSL_add_all_algorithms();
  OPENSSL_config(NULL);

  /* Encrypt the plaintext */
  /*
   ciphertext_len = encrypt (newplain, strlen ((unsigned char *)newplain), realKey, realiv,
                             ciphertext);

   printf("Output: %s %d\n", ciphertext, ciphertext_len);
   char *base64EncodeOutput;
   Base64Encode(ciphertext, ciphertext_len, &base64EncodeOutput);
   printf("Output (base64): %s\n", base64EncodeOutput);
   */


   Base64Decode(newkryptogram, &krypto64decoded, &krypto64decoded_len);

   int thcount = 8;
   Przek tabprzek[thcount];

   int j;
   for(j = 0; j < thcount; ++j)
   {
       tabprzek[j].klucz = realKey;
       tabprzek[j].iv = realiv;
       tabprzek[j].krypt64declen = krypto64decoded_len;
       tabprzek[j].krypt64dec = krypto64decoded;
       tabprzek[j].th_number = j;
       tabprzek[j].th_max = thcount;
   }


   HANDLE tab[thcount];

   for(j = 0; j < thcount; j++)
   {
       tab[j] = CreateThread(NULL, 0, ThreadFunc, (void *)&tabprzek[j], 0, NULL);
   }


    WaitForMultipleObjects(thcount, tab, TRUE, INFINITE);


 /* Clean up */
  EVP_cleanup();
  ERR_free_strings();

  return 0;
}
