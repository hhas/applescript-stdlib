FasdUAS 1.101.10   ��   ��    k             l      ��  ��   �� FormatLib -- parse and format AppleScript values

Notes:

- NSNumberFormatters, NSDateFormatters, etc. (like all other ASOC objects) shouldn't be retained in library (or script objects returned by it) as that breaks store script/save/autosave (caveat: if there is a significant performance difference between creating a formatter once and reusing it vs creating it each time, DateFormatterObjects could be returned as an _alternative_ to using `parse date`/`format date` handlers where user really needs the extra speed; however, documentation would need to state clearly that returned object contains ASOC data so can cause autosave, etc. to fail)


TO DO:

- `format object theData using theTemplate`; theTemplate should be a template string, or a `source code format` (the default) or `human readable format` constant

	- if theTemplate is a constant, theData is formatted as-is (in which case it doesn't have to be a list) using OSADisplay
	
	 - if theTemplate is text, theData should be a list of values to insert into the corresponding placeholders (note: use same $1, $2, etc format as `search text`'s `replacing with TEMPLATE`); need to decide how non-text values are treated
	 
	 
- note that `format object` is problematic to implement for some types, as it'll require an AE handler-based implementation to convert some types (e.g. records, references) as ASOC can't convert script objects to NSAppleEventDescriptors, so there's no way to call OSAKit directly (FWIW, writing a script object to temp file via `store script` and reading that into OSALanguage would probably work, but would be slow and humiliatingly hacky); a custom OSAX/event handler wouldn't need to do much: just take a script object (which `format object` would create as a portable wrapper for theData), execute it (the script would just return a value), and get source code (and/or human-readable representation) of the result

- not sure about formatting type class and symbol constants (IIRC, AS only binds application info to reference objects, not type/constant objects, in which case only terms defined in AS's own dictionary will format as keywords and the rest will format using raw chevron syntax unless the appropriate app's terminology is forcibly loaded into AS interpreter at runtime (e.g. using `run script` trickery, or when running scripts in SE)


- `format number`, `parse number` -- canonical/locale-aware options (e.g. decimal, thousands separators), min/max significant places, etc; need to see what Cocoa has available

- note that DateLib and MathLib should also provide their own standard `convert text to TYPE` and `convert TYPE to text` handlers that receive/return a canonical string (e.g. ISO8601, numbers that always use period as decimal separator); unlike using `as` operator to coerce values, this will guarantee reliable conversions from/to text without AS's own current localization settings causing inconsistent/failed results

- what, if any, localization info (via NSLocale) might be relevant/useful to AS users?


     � 	 	�   F o r m a t L i b   - -   p a r s e   a n d   f o r m a t   A p p l e S c r i p t   v a l u e s 
 
 N o t e s : 
 
 -   N S N u m b e r F o r m a t t e r s ,   N S D a t e F o r m a t t e r s ,   e t c .   ( l i k e   a l l   o t h e r   A S O C   o b j e c t s )   s h o u l d n ' t   b e   r e t a i n e d   i n   l i b r a r y   ( o r   s c r i p t   o b j e c t s   r e t u r n e d   b y   i t )   a s   t h a t   b r e a k s   s t o r e   s c r i p t / s a v e / a u t o s a v e   ( c a v e a t :   i f   t h e r e   i s   a   s i g n i f i c a n t   p e r f o r m a n c e   d i f f e r e n c e   b e t w e e n   c r e a t i n g   a   f o r m a t t e r   o n c e   a n d   r e u s i n g   i t   v s   c r e a t i n g   i t   e a c h   t i m e ,   D a t e F o r m a t t e r O b j e c t s   c o u l d   b e   r e t u r n e d   a s   a n   _ a l t e r n a t i v e _   t o   u s i n g   ` p a r s e   d a t e ` / ` f o r m a t   d a t e `   h a n d l e r s   w h e r e   u s e r   r e a l l y   n e e d s   t h e   e x t r a   s p e e d ;   h o w e v e r ,   d o c u m e n t a t i o n   w o u l d   n e e d   t o   s t a t e   c l e a r l y   t h a t   r e t u r n e d   o b j e c t   c o n t a i n s   A S O C   d a t a   s o   c a n   c a u s e   a u t o s a v e ,   e t c .   t o   f a i l ) 
 
 
 T O   D O : 
 
 -   ` f o r m a t   o b j e c t   t h e D a t a   u s i n g   t h e T e m p l a t e ` ;   t h e T e m p l a t e   s h o u l d   b e   a   t e m p l a t e   s t r i n g ,   o r   a   ` s o u r c e   c o d e   f o r m a t `   ( t h e   d e f a u l t )   o r   ` h u m a n   r e a d a b l e   f o r m a t `   c o n s t a n t 
 
 	 -   i f   t h e T e m p l a t e   i s   a   c o n s t a n t ,   t h e D a t a   i s   f o r m a t t e d   a s - i s   ( i n   w h i c h   c a s e   i t   d o e s n ' t   h a v e   t o   b e   a   l i s t )   u s i n g   O S A D i s p l a y 
 	 
 	   -   i f   t h e T e m p l a t e   i s   t e x t ,   t h e D a t a   s h o u l d   b e   a   l i s t   o f   v a l u e s   t o   i n s e r t   i n t o   t h e   c o r r e s p o n d i n g   p l a c e h o l d e r s   ( n o t e :   u s e   s a m e   $ 1 ,   $ 2 ,   e t c   f o r m a t   a s   ` s e a r c h   t e x t ` ' s   ` r e p l a c i n g   w i t h   T E M P L A T E ` ) ;   n e e d   t o   d e c i d e   h o w   n o n - t e x t   v a l u e s   a r e   t r e a t e d 
 	   
 	   
 -   n o t e   t h a t   ` f o r m a t   o b j e c t `   i s   p r o b l e m a t i c   t o   i m p l e m e n t   f o r   s o m e   t y p e s ,   a s   i t ' l l   r e q u i r e   a n   A E   h a n d l e r - b a s e d   i m p l e m e n t a t i o n   t o   c o n v e r t   s o m e   t y p e s   ( e . g .   r e c o r d s ,   r e f e r e n c e s )   a s   A S O C   c a n ' t   c o n v e r t   s c r i p t   o b j e c t s   t o   N S A p p l e E v e n t D e s c r i p t o r s ,   s o   t h e r e ' s   n o   w a y   t o   c a l l   O S A K i t   d i r e c t l y   ( F W I W ,   w r i t i n g   a   s c r i p t   o b j e c t   t o   t e m p   f i l e   v i a   ` s t o r e   s c r i p t `   a n d   r e a d i n g   t h a t   i n t o   O S A L a n g u a g e   w o u l d   p r o b a b l y   w o r k ,   b u t   w o u l d   b e   s l o w   a n d   h u m i l i a t i n g l y   h a c k y ) ;   a   c u s t o m   O S A X / e v e n t   h a n d l e r   w o u l d n ' t   n e e d   t o   d o   m u c h :   j u s t   t a k e   a   s c r i p t   o b j e c t   ( w h i c h   ` f o r m a t   o b j e c t `   w o u l d   c r e a t e   a s   a   p o r t a b l e   w r a p p e r   f o r   t h e D a t a ) ,   e x e c u t e   i t   ( t h e   s c r i p t   w o u l d   j u s t   r e t u r n   a   v a l u e ) ,   a n d   g e t   s o u r c e   c o d e   ( a n d / o r   h u m a n - r e a d a b l e   r e p r e s e n t a t i o n )   o f   t h e   r e s u l t 
 
 -   n o t   s u r e   a b o u t   f o r m a t t i n g   t y p e   c l a s s   a n d   s y m b o l   c o n s t a n t s   ( I I R C ,   A S   o n l y   b i n d s   a p p l i c a t i o n   i n f o   t o   r e f e r e n c e   o b j e c t s ,   n o t   t y p e / c o n s t a n t   o b j e c t s ,   i n   w h i c h   c a s e   o n l y   t e r m s   d e f i n e d   i n   A S ' s   o w n   d i c t i o n a r y   w i l l   f o r m a t   a s   k e y w o r d s   a n d   t h e   r e s t   w i l l   f o r m a t   u s i n g   r a w   c h e v r o n   s y n t a x   u n l e s s   t h e   a p p r o p r i a t e   a p p ' s   t e r m i n o l o g y   i s   f o r c i b l y   l o a d e d   i n t o   A S   i n t e r p r e t e r   a t   r u n t i m e   ( e . g .   u s i n g   ` r u n   s c r i p t `   t r i c k e r y ,   o r   w h e n   r u n n i n g   s c r i p t s   i n   S E ) 
 
 
 -   ` f o r m a t   n u m b e r ` ,   ` p a r s e   n u m b e r `   - -   c a n o n i c a l / l o c a l e - a w a r e   o p t i o n s   ( e . g .   d e c i m a l ,   t h o u s a n d s   s e p a r a t o r s ) ,   m i n / m a x   s i g n i f i c a n t   p l a c e s ,   e t c ;   n e e d   t o   s e e   w h a t   C o c o a   h a s   a v a i l a b l e 
 
 -   n o t e   t h a t   D a t e L i b   a n d   M a t h L i b   s h o u l d   a l s o   p r o v i d e   t h e i r   o w n   s t a n d a r d   ` c o n v e r t   t e x t   t o   T Y P E `   a n d   ` c o n v e r t   T Y P E   t o   t e x t `   h a n d l e r s   t h a t   r e c e i v e / r e t u r n   a   c a n o n i c a l   s t r i n g   ( e . g .   I S O 8 6 0 1 ,   n u m b e r s   t h a t   a l w a y s   u s e   p e r i o d   a s   d e c i m a l   s e p a r a t o r ) ;   u n l i k e   u s i n g   ` a s `   o p e r a t o r   t o   c o e r c e   v a l u e s ,   t h i s   w i l l   g u a r a n t e e   r e l i a b l e   c o n v e r s i o n s   f r o m / t o   t e x t   w i t h o u t   A S ' s   o w n   c u r r e n t   l o c a l i z a t i o n   s e t t i n g s   c a u s i n g   i n c o n s i s t e n t / f a i l e d   r e s u l t s 
 
 -   w h a t ,   i f   a n y ,   l o c a l i z a t i o n   i n f o   ( v i a   N S L o c a l e )   m i g h t   b e   r e l e v a n t / u s e f u l   t o   A S   u s e r s ? 
 
 
   
  
 l     ��������  ��  ��        x     �� ����    4    �� 
�� 
frmk  m       �    F o u n d a t i o n��        l     ��������  ��  ��        l      ����  q         ������ 0 f  ��  ��  ��        l     ����  r         n        I    �������� 0 init  ��  ��    n         I    �������� 	0 alloc  ��  ��     n     ! " ! o    ���� &0 nsnumberformatter NSNumberFormatter " m     ��
�� misccura  o      ���� 0 f  ��  ��     # $ # l     ��������  ��  ��   $  % & % l    '���� ' c     ( ) ( n    * + * I    ��������  0 positiveprefix positivePrefix��  ��   + o    ���� 0 f   ) m    ��
�� 
ctxt��  ��   &  , - , l    . / 0 . n    1 2 1 I    �������� B0 textattributesfornegativevalues textAttributesForNegativeValues��  ��   2 o    ���� 0 f   /  as anything    0 � 3 3  a s   a n y t h i n g -  4 5 4 l     ��������  ��  ��   5  6 7 6 l      �� 8 9��   81+

NSNumberFormatter.numberStyle

   NSNumberFormatterNoStyle
   NSNumberFormatterDecimalStyle
   NSNumberFormatterCurrencyStyle
   NSNumberFormatterPercentStyle
   NSNumberFormatterScientificStyle
   NSNumberFormatterSpellOutStyle
   
   negativeFormat
   positiveFormat
   minusSign
   plusSign
   zeroSymbol
 positivePrefix,positiveSuffix,negativePrefix,negativeSuffix

 

   
   groupingSeparator, usesGroupingSeparator -- 1000s grouping
  decimalSeparator,
   
   thousandSeparator
   hasThousandSeparators
   
� numberFromString:
� stringFromNumber:
    9 � : :V 
 
 N S N u m b e r F o r m a t t e r . n u m b e r S t y l e 
 
       N S N u m b e r F o r m a t t e r N o S t y l e 
       N S N u m b e r F o r m a t t e r D e c i m a l S t y l e 
       N S N u m b e r F o r m a t t e r C u r r e n c y S t y l e 
       N S N u m b e r F o r m a t t e r P e r c e n t S t y l e 
       N S N u m b e r F o r m a t t e r S c i e n t i f i c S t y l e 
       N S N u m b e r F o r m a t t e r S p e l l O u t S t y l e 
       
       n e g a t i v e F o r m a t 
       p o s i t i v e F o r m a t 
       m i n u s S i g n 
       p l u s S i g n 
       z e r o S y m b o l 
   p o s i t i v e P r e f i x , p o s i t i v e S u f f i x , n e g a t i v e P r e f i x , n e g a t i v e S u f f i x 
 
   
 
       
       g r o u p i n g S e p a r a t o r ,   u s e s G r o u p i n g S e p a r a t o r   - -   1 0 0 0 s   g r o u p i n g 
     d e c i m a l S e p a r a t o r , 
       
       t h o u s a n d S e p a r a t o r 
       h a s T h o u s a n d S e p a r a t o r s 
       
    n u m b e r F r o m S t r i n g : 
    s t r i n g F r o m N u m b e r : 
 7  ; < ; l     ��������  ��  ��   <  =�� = l     ��������  ��  ��  ��       �� > ? @��   > ����
�� 
pimr
�� .aevtoappnull  �   � **** ? �� A��  A   B B �� C��
�� 
cobj C  D D   �� 
�� 
frmk��   @ �� E���� F G��
�� .aevtoappnull  �   � **** E k      H H   I I   J J  % K K  ,����  ��  ��   F ���� 0 f   G ��������������
�� misccura�� &0 nsnumberformatter NSNumberFormatter�� 	0 alloc  �� 0 init  ��  0 positiveprefix positivePrefix
�� 
ctxt�� B0 textattributesfornegativevalues textAttributesForNegativeValues�� ��,j+ j+ E�O�j+ �&O�j+ ascr  ��ޭ