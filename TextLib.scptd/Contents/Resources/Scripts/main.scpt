FasdUAS 1.101.10   ��   ��    k             l      ��  ��    TextLib -- commonly-used text processing commands

Caution: When matching text item delimiters in text value, AppleScript uses the current scope's existing considering/ignoring case, diacriticals, hyphens, punctuation, white space and numeric strings settings; thus, wrapping a `search text` command in different considering/ignoring blocks can produce different results. For example, `search text "fud" for "F" will normally match the first character since AppleScript uses case-insensitive matching by default, whereas enclosing it in a `considering case` block will cause the same command to return zero matches. Conversely, `search text "f ud" for "fu"` will normally return zero matches as AppleScript considers white space by default, but when enclosed in an `ignoring white space` block will match the first three characters: "f u". This is how AppleScript is designed to work, but users need to be reminded of this as considering/ignoring blocks affect ALL script handlers called within that block, including nested calls (and all to any osax and application handlers that understand considering/ignoring attributes). (A much safer design would've restricted considering/ignoring blocks effect to their lexical scope by default; individual handlers would then using standard considering/ignoring behavior by default unless they use a `considering current options` block to indicate that the calling code's current considering/ignoring options should be used.)

TO DO:

- what about Unicode normalization when searching/comparing NSStrings? or does NSString/NSRegularExpression deal with that already? (i.e. are there any current use cases where explicit NSString normalization is required? probably not, but best confirm)

- decide if predefined considering/ignoring options in `search text`, etc. should consider or ignore diacriticals and numeric strings; once decided, use same combinations for ListLib's text comparator for consistency

- also provide `exact match` option in `search text`/`split text` that considers case, diacriticals, hyphens, punctuation and white space but ignores numeric strings? currently, the `case insensitivity` and `case sensitivity` options both consider numeric strings (BTW, it might be better to replace `case sensitivity` with `exact match` to avoid having too many confusing options); also check just how much `considering numeric strings` affects matching (as opposed to ordering, which is its real intention)

- to normalize text theText using normalizationForm -- Q. how does AS normally deal with composed vs decomposed unicode chars? (will need to run tests to determine); note that Satimage.osax provides a `normalize unicode` command, although it only covers 2 of 4 forms (most likely KD and KC) -- TO DO: use `precomposed characters` and `compatibility mapping` boolean params? (also, need to figure out which is preferred form to use as default)
		decomposedStringWithCanonicalMapping (Unicode Normalization Form D)
		decomposedStringWithCompatibilityMapping (Unicode Normalization Form KD)
		precomposedStringWithCanonicalMapping (Unicode Normalization Form C)
		precomposedStringWithCompatibilityMapping (Unicode Normalization Form KC)



- `insert into text`, `delete from text` for inserting/replacing/deleting ranges of characters (c.f. `insert into list`, `delete from list` in ListLib)


- add `matching first item only` boolean option to `search text` (this allows users to perform incremental matching fairly efficiently without having to use an Iterator API)

- also allow `search text` handler's `replacing with` parameter to accept a script object containing a `replacementText` handler; this would take the match record produced by _findText()/_findPattern() and return the text to insert; useful when the replacement text is based on the original, e.g. when uppercasing matched text the user currently has to get a list of match records from `search text`, then iterate over it and replace each text range herself


- would it be worth implementing a `compare text` command that allows considering/ignoring options to be supplied as `considering`/`ignoring` parameters (considering/ignoring blocks can't be parameterized as they require hardcoded constants) as this would allow comparisons to be safely performed without having to futz with considering/ignoring blocks all the time (c.f. MathLib's `compare number`); for extra flexibility, the comparator constructor should also be exposed as a public command, and the returned object implement the same `makeKey`+`compareItems` methods as ListLib's sort comparators, allowing them to be used interchangeably (one could even argue for putting all comparators into their own lib, which other libraries and user scripts can import whenever they need to parameterize comparison behavior)

- Q. what difference does locale make to uppercase/capitalize/lowercase text?
     � 	 	&*   T e x t L i b   - -   c o m m o n l y - u s e d   t e x t   p r o c e s s i n g   c o m m a n d s 
 
 C a u t i o n :   W h e n   m a t c h i n g   t e x t   i t e m   d e l i m i t e r s   i n   t e x t   v a l u e ,   A p p l e S c r i p t   u s e s   t h e   c u r r e n t   s c o p e ' s   e x i s t i n g   c o n s i d e r i n g / i g n o r i n g   c a s e ,   d i a c r i t i c a l s ,   h y p h e n s ,   p u n c t u a t i o n ,   w h i t e   s p a c e   a n d   n u m e r i c   s t r i n g s   s e t t i n g s ;   t h u s ,   w r a p p i n g   a   ` s e a r c h   t e x t `   c o m m a n d   i n   d i f f e r e n t   c o n s i d e r i n g / i g n o r i n g   b l o c k s   c a n   p r o d u c e   d i f f e r e n t   r e s u l t s .   F o r   e x a m p l e ,   ` s e a r c h   t e x t   " f u d "   f o r   " F "   w i l l   n o r m a l l y   m a t c h   t h e   f i r s t   c h a r a c t e r   s i n c e   A p p l e S c r i p t   u s e s   c a s e - i n s e n s i t i v e   m a t c h i n g   b y   d e f a u l t ,   w h e r e a s   e n c l o s i n g   i t   i n   a   ` c o n s i d e r i n g   c a s e `   b l o c k   w i l l   c a u s e   t h e   s a m e   c o m m a n d   t o   r e t u r n   z e r o   m a t c h e s .   C o n v e r s e l y ,   ` s e a r c h   t e x t   " f   u d "   f o r   " f u " `   w i l l   n o r m a l l y   r e t u r n   z e r o   m a t c h e s   a s   A p p l e S c r i p t   c o n s i d e r s   w h i t e   s p a c e   b y   d e f a u l t ,   b u t   w h e n   e n c l o s e d   i n   a n   ` i g n o r i n g   w h i t e   s p a c e `   b l o c k   w i l l   m a t c h   t h e   f i r s t   t h r e e   c h a r a c t e r s :   " f   u " .   T h i s   i s   h o w   A p p l e S c r i p t   i s   d e s i g n e d   t o   w o r k ,   b u t   u s e r s   n e e d   t o   b e   r e m i n d e d   o f   t h i s   a s   c o n s i d e r i n g / i g n o r i n g   b l o c k s   a f f e c t   A L L   s c r i p t   h a n d l e r s   c a l l e d   w i t h i n   t h a t   b l o c k ,   i n c l u d i n g   n e s t e d   c a l l s   ( a n d   a l l   t o   a n y   o s a x   a n d   a p p l i c a t i o n   h a n d l e r s   t h a t   u n d e r s t a n d   c o n s i d e r i n g / i g n o r i n g   a t t r i b u t e s ) .   ( A   m u c h   s a f e r   d e s i g n   w o u l d ' v e   r e s t r i c t e d   c o n s i d e r i n g / i g n o r i n g   b l o c k s   e f f e c t   t o   t h e i r   l e x i c a l   s c o p e   b y   d e f a u l t ;   i n d i v i d u a l   h a n d l e r s   w o u l d   t h e n   u s i n g   s t a n d a r d   c o n s i d e r i n g / i g n o r i n g   b e h a v i o r   b y   d e f a u l t   u n l e s s   t h e y   u s e   a   ` c o n s i d e r i n g   c u r r e n t   o p t i o n s `   b l o c k   t o   i n d i c a t e   t h a t   t h e   c a l l i n g   c o d e ' s   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   o p t i o n s   s h o u l d   b e   u s e d . ) 
 
 T O   D O : 
 
 -   w h a t   a b o u t   U n i c o d e   n o r m a l i z a t i o n   w h e n   s e a r c h i n g / c o m p a r i n g   N S S t r i n g s ?   o r   d o e s   N S S t r i n g / N S R e g u l a r E x p r e s s i o n   d e a l   w i t h   t h a t   a l r e a d y ?   ( i . e .   a r e   t h e r e   a n y   c u r r e n t   u s e   c a s e s   w h e r e   e x p l i c i t   N S S t r i n g   n o r m a l i z a t i o n   i s   r e q u i r e d ?   p r o b a b l y   n o t ,   b u t   b e s t   c o n f i r m ) 
 
 -   d e c i d e   i f   p r e d e f i n e d   c o n s i d e r i n g / i g n o r i n g   o p t i o n s   i n   ` s e a r c h   t e x t ` ,   e t c .   s h o u l d   c o n s i d e r   o r   i g n o r e   d i a c r i t i c a l s   a n d   n u m e r i c   s t r i n g s ;   o n c e   d e c i d e d ,   u s e   s a m e   c o m b i n a t i o n s   f o r   L i s t L i b ' s   t e x t   c o m p a r a t o r   f o r   c o n s i s t e n c y 
 
 -   a l s o   p r o v i d e   ` e x a c t   m a t c h `   o p t i o n   i n   ` s e a r c h   t e x t ` / ` s p l i t   t e x t `   t h a t   c o n s i d e r s   c a s e ,   d i a c r i t i c a l s ,   h y p h e n s ,   p u n c t u a t i o n   a n d   w h i t e   s p a c e   b u t   i g n o r e s   n u m e r i c   s t r i n g s ?   c u r r e n t l y ,   t h e   ` c a s e   i n s e n s i t i v i t y `   a n d   ` c a s e   s e n s i t i v i t y `   o p t i o n s   b o t h   c o n s i d e r   n u m e r i c   s t r i n g s   ( B T W ,   i t   m i g h t   b e   b e t t e r   t o   r e p l a c e   ` c a s e   s e n s i t i v i t y `   w i t h   ` e x a c t   m a t c h `   t o   a v o i d   h a v i n g   t o o   m a n y   c o n f u s i n g   o p t i o n s ) ;   a l s o   c h e c k   j u s t   h o w   m u c h   ` c o n s i d e r i n g   n u m e r i c   s t r i n g s `   a f f e c t s   m a t c h i n g   ( a s   o p p o s e d   t o   o r d e r i n g ,   w h i c h   i s   i t s   r e a l   i n t e n t i o n ) 
 
 -   t o   n o r m a l i z e   t e x t   t h e T e x t   u s i n g   n o r m a l i z a t i o n F o r m   - -   Q .   h o w   d o e s   A S   n o r m a l l y   d e a l   w i t h   c o m p o s e d   v s   d e c o m p o s e d   u n i c o d e   c h a r s ?   ( w i l l   n e e d   t o   r u n   t e s t s   t o   d e t e r m i n e ) ;   n o t e   t h a t   S a t i m a g e . o s a x   p r o v i d e s   a   ` n o r m a l i z e   u n i c o d e `   c o m m a n d ,   a l t h o u g h   i t   o n l y   c o v e r s   2   o f   4   f o r m s   ( m o s t   l i k e l y   K D   a n d   K C )   - -   T O   D O :   u s e   ` p r e c o m p o s e d   c h a r a c t e r s `   a n d   ` c o m p a t i b i l i t y   m a p p i n g `   b o o l e a n   p a r a m s ?   ( a l s o ,   n e e d   t o   f i g u r e   o u t   w h i c h   i s   p r e f e r r e d   f o r m   t o   u s e   a s   d e f a u l t ) 
 	 	 d e c o m p o s e d S t r i n g W i t h C a n o n i c a l M a p p i n g   ( U n i c o d e   N o r m a l i z a t i o n   F o r m   D ) 
 	 	 d e c o m p o s e d S t r i n g W i t h C o m p a t i b i l i t y M a p p i n g   ( U n i c o d e   N o r m a l i z a t i o n   F o r m   K D ) 
 	 	 p r e c o m p o s e d S t r i n g W i t h C a n o n i c a l M a p p i n g   ( U n i c o d e   N o r m a l i z a t i o n   F o r m   C ) 
 	 	 p r e c o m p o s e d S t r i n g W i t h C o m p a t i b i l i t y M a p p i n g   ( U n i c o d e   N o r m a l i z a t i o n   F o r m   K C ) 
 
 
 
 -   ` i n s e r t   i n t o   t e x t ` ,   ` d e l e t e   f r o m   t e x t `   f o r   i n s e r t i n g / r e p l a c i n g / d e l e t i n g   r a n g e s   o f   c h a r a c t e r s   ( c . f .   ` i n s e r t   i n t o   l i s t ` ,   ` d e l e t e   f r o m   l i s t `   i n   L i s t L i b ) 
 
 
 -   a d d   ` m a t c h i n g   f i r s t   i t e m   o n l y `   b o o l e a n   o p t i o n   t o   ` s e a r c h   t e x t `   ( t h i s   a l l o w s   u s e r s   t o   p e r f o r m   i n c r e m e n t a l   m a t c h i n g   f a i r l y   e f f i c i e n t l y   w i t h o u t   h a v i n g   t o   u s e   a n   I t e r a t o r   A P I ) 
 
 -   a l s o   a l l o w   ` s e a r c h   t e x t `   h a n d l e r ' s   ` r e p l a c i n g   w i t h `   p a r a m e t e r   t o   a c c e p t   a   s c r i p t   o b j e c t   c o n t a i n i n g   a   ` r e p l a c e m e n t T e x t `   h a n d l e r ;   t h i s   w o u l d   t a k e   t h e   m a t c h   r e c o r d   p r o d u c e d   b y   _ f i n d T e x t ( ) / _ f i n d P a t t e r n ( )   a n d   r e t u r n   t h e   t e x t   t o   i n s e r t ;   u s e f u l   w h e n   t h e   r e p l a c e m e n t   t e x t   i s   b a s e d   o n   t h e   o r i g i n a l ,   e . g .   w h e n   u p p e r c a s i n g   m a t c h e d   t e x t   t h e   u s e r   c u r r e n t l y   h a s   t o   g e t   a   l i s t   o f   m a t c h   r e c o r d s   f r o m   ` s e a r c h   t e x t ` ,   t h e n   i t e r a t e   o v e r   i t   a n d   r e p l a c e   e a c h   t e x t   r a n g e   h e r s e l f 
 
 
 -   w o u l d   i t   b e   w o r t h   i m p l e m e n t i n g   a   ` c o m p a r e   t e x t `   c o m m a n d   t h a t   a l l o w s   c o n s i d e r i n g / i g n o r i n g   o p t i o n s   t o   b e   s u p p l i e d   a s   ` c o n s i d e r i n g ` / ` i g n o r i n g `   p a r a m e t e r s   ( c o n s i d e r i n g / i g n o r i n g   b l o c k s   c a n ' t   b e   p a r a m e t e r i z e d   a s   t h e y   r e q u i r e   h a r d c o d e d   c o n s t a n t s )   a s   t h i s   w o u l d   a l l o w   c o m p a r i s o n s   t o   b e   s a f e l y   p e r f o r m e d   w i t h o u t   h a v i n g   t o   f u t z   w i t h   c o n s i d e r i n g / i g n o r i n g   b l o c k s   a l l   t h e   t i m e   ( c . f .   M a t h L i b ' s   ` c o m p a r e   n u m b e r ` ) ;   f o r   e x t r a   f l e x i b i l i t y ,   t h e   c o m p a r a t o r   c o n s t r u c t o r   s h o u l d   a l s o   b e   e x p o s e d   a s   a   p u b l i c   c o m m a n d ,   a n d   t h e   r e t u r n e d   o b j e c t   i m p l e m e n t   t h e   s a m e   ` m a k e K e y ` + ` c o m p a r e I t e m s `   m e t h o d s   a s   L i s t L i b ' s   s o r t   c o m p a r a t o r s ,   a l l o w i n g   t h e m   t o   b e   u s e d   i n t e r c h a n g e a b l y   ( o n e   c o u l d   e v e n   a r g u e   f o r   p u t t i n g   a l l   c o m p a r a t o r s   i n t o   t h e i r   o w n   l i b ,   w h i c h   o t h e r   l i b r a r i e s   a n d   u s e r   s c r i p t s   c a n   i m p o r t   w h e n e v e r   t h e y   n e e d   t o   p a r a m e t e r i z e   c o m p a r i s o n   b e h a v i o r ) 
 
 -   Q .   w h a t   d i f f e r e n c e   d o e s   l o c a l e   m a k e   t o   u p p e r c a s e / c a p i t a l i z e / l o w e r c a s e   t e x t ? 
   
  
 l     ��������  ��  ��        x     �� ����    4    �� 
�� 
frmk  m       �    F o u n d a t i o n��        l     ��������  ��  ��        l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��      record types     �      r e c o r d   t y p e s      l     ��������  ��  ��       !   j    �� "�� (0 _unmatchedtexttype _UnmatchedTextType " m    ��
�� 
TxtU !  # $ # j    �� %�� $0 _matchedtexttype _MatchedTextType % m    ��
�� 
TxtM $  & ' & j    �� (�� &0 _matchedgrouptype _MatchedGroupType ( m    ��
�� 
TxtG '  ) * ) l     ��������  ��  ��   *  + , + l     ��������  ��  ��   ,  - . - l     �� / 0��   / J D--------------------------------------------------------------------    0 � 1 1 � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - .  2 3 2 l     �� 4 5��   4   support    5 � 6 6    s u p p o r t 3  7 8 7 l     ��������  ��  ��   8  9 : 9 l      ; < = ; j    �� >�� 0 _supportlib _supportLib > N     ? ? 4    �� @
�� 
scpt @ m     A A � B B " L i b r a r y S u p p o r t L i b < "  used for parameter checking    = � C C 8   u s e d   f o r   p a r a m e t e r   c h e c k i n g :  D E D l     ��������  ��  ��   E  F G F l     ��������  ��  ��   G  H I H i    J K J I      �� L���� 
0 _error   L  M N M o      ���� 0 handlername handlerName N  O P O o      ���� 0 etext eText P  Q R Q o      ���� 0 enumber eNumber R  S T S o      ���� 0 efrom eFrom T  U�� U o      ���� 
0 eto eTo��  ��   K n     V W V I    �� X���� &0 throwcommanderror throwCommandError X  Y Z Y m     [ [ � \ \  T e x t L i b Z  ] ^ ] o    ���� 0 handlername handlerName ^  _ ` _ o    ���� 0 etext eText `  a b a o    	���� 0 enumber eNumber b  c d c o   	 
���� 0 efrom eFrom d  e�� e o   
 ���� 
0 eto eTo��  ��   W o     ���� 0 _supportlib _supportLib I  f g f l     ��������  ��  ��   g  h i h l     ��������  ��  ��   i  j k j l     �� l m��   l J D--------------------------------------------------------------------    m � n n � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - k  o p o l     �� q r��   q   Find and Replace Suite    r � s s .   F i n d   a n d   R e p l a c e   S u i t e p  t u t l     ��������  ��  ��   u  v w v i   " x y x I      �� z���� 60 _compileregularexpression _compileRegularExpression z  {�� { o      ���� 0 patterntext patternText��  ��   y k     " | |  } ~ } r       �  n    
 � � � I    
�� ����� Z0 +regularexpressionwithpattern_options_error_ +regularExpressionWithPattern_options_error_ �  � � � o    ���� 0 patterntext patternText �  � � � m    ����   �  ��� � l    ����� � m    ��
�� 
msng��  ��  ��  ��   � n     � � � o    ���� *0 nsregularexpression NSRegularExpression � m     ��
�� misccura � o      ���� 
0 regexp   ~  � � � Z    � ����� � =    � � � o    ���� 
0 regexp   � m    ��
�� 
msng � R    �� � �
�� .ascrerr ****      � **** � m     � � � � � \ I n v a l i d    f o r    p a r a m e t e r   ( n o t   a   v a l i d   p a t t e r n ) . � �� � �
�� 
errn � m    �����Y � �� ���
�� 
erob � o    ���� 0 patterntext patternText��  ��  ��   �  ��� � L     " � � o     !���� 
0 regexp  ��   w  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �   find pattern    � � � �    f i n d   p a t t e r n �  � � � l     ��������  ��  ��   �  � � � i  # & � � � I      �� ����� $0 _matchinforecord _matchInfoRecord �  � � � o      ���� 0 
asocstring 
asocString �  � � � o      ����  0 asocmatchrange asocMatchRange �  � � � o      ���� 0 
textoffset 
textOffset �  ��� � o      ���� 0 
recordtype 
recordType��  ��   � k     # � �  � � � r     
 � � � c      � � � l     ����� � n     � � � I    �� ����� *0 substringwithrange_ substringWithRange_ �  ��� � o    ����  0 asocmatchrange asocMatchRange��  ��   � o     ���� 0 
asocstring 
asocString��  ��   � m    ��
�� 
ctxt � o      ���� 0 	foundtext 	foundText �  � � � l    � � � � r     � � � [     � � � o    ���� 0 
textoffset 
textOffset � l    ����� � n     � � � 1    ��
�� 
leng � o    ���� 0 	foundtext 	foundText��  ��   � o      ����  0 nexttextoffset nextTextOffset � : 4 calculate the start index of the next AS text range    � � � � h   c a l c u l a t e   t h e   s t a r t   i n d e x   o f   t h e   n e x t   A S   t e x t   r a n g e �  � � � l   � � ��   �
 note: record keys are identifiers, not keywords, as 1. library-defined keywords are a huge pain to use outside of `tell script...` blocks and 2. importing the library's terminology into the global namespace via `use script...` is an excellent way to create keyword conflicts; only the class value is a keyword since Script Editor/OSAKit don't correctly handle records that use non-typename values (e.g. `{class:"matched text",...}`), but this shouldn't impact usability as it's really only used for informational purposes    � � � �   n o t e :   r e c o r d   k e y s   a r e   i d e n t i f i e r s ,   n o t   k e y w o r d s ,   a s   1 .   l i b r a r y - d e f i n e d   k e y w o r d s   a r e   a   h u g e   p a i n   t o   u s e   o u t s i d e   o f   ` t e l l   s c r i p t . . . `   b l o c k s   a n d   2 .   i m p o r t i n g   t h e   l i b r a r y ' s   t e r m i n o l o g y   i n t o   t h e   g l o b a l   n a m e s p a c e   v i a   ` u s e   s c r i p t . . . `   i s   a n   e x c e l l e n t   w a y   t o   c r e a t e   k e y w o r d   c o n f l i c t s ;   o n l y   t h e   c l a s s   v a l u e   i s   a   k e y w o r d   s i n c e   S c r i p t   E d i t o r / O S A K i t   d o n ' t   c o r r e c t l y   h a n d l e   r e c o r d s   t h a t   u s e   n o n - t y p e n a m e   v a l u e s   ( e . g .   ` { c l a s s : " m a t c h e d   t e x t " , . . . } ` ) ,   b u t   t h i s   s h o u l d n ' t   i m p a c t   u s a b i l i t y   a s   i t ' s   r e a l l y   o n l y   u s e d   f o r   i n f o r m a t i o n a l   p u r p o s e s �  ��~ � l   # � � � � L    # � � J    " � �  � � � K     � � �} � �
�} 
pcls � o    �|�| 0 
recordtype 
recordType � �{ � ��{ 0 
startindex 
startIndex � o    �z�z 0 
textoffset 
textOffset � �y � ��y 0 endindex endIndex � \     � � � o    �x�x  0 nexttextoffset nextTextOffset � m    �w�w  � �v ��u�v 0 	foundtext 	foundText � o    �t�t 0 	foundtext 	foundText�u   �  ��s � o     �r�r  0 nexttextoffset nextTextOffset�s   �  y TO DO: use fromIndex/toIndex instead of startIndex/endIndex? (see also ListLib; consistent naming would be good to have)    � � � � �   T O   D O :   u s e   f r o m I n d e x / t o I n d e x   i n s t e a d   o f   s t a r t I n d e x / e n d I n d e x ?   ( s e e   a l s o   L i s t L i b ;   c o n s i s t e n t   n a m i n g   w o u l d   b e   g o o d   t o   h a v e )�~   �  � � � l     �q�p�o�q  �p  �o   �  � � � l     �n�m�l�n  �m  �l   �  � � � i  ' * � � � I      �k ��j�k 0 _matchrecords _matchRecords �  � � � o      �i�i 0 
asocstring 
asocString �  � � � o      �h�h  0 asocmatchrange asocMatchRange �  � � � o      �g�g  0 asocstartindex asocStartIndex �  � � � o      �f�f 0 
textoffset 
textOffset �  � � � o      �e�e (0 nonmatchrecordtype nonMatchRecordType �  ��d � o      �c�c "0 matchrecordtype matchRecordType�d  �j   � k     V � �  � � � l     �b � ��b   � � � important: NSString character indexes aren't guaranteed to be same as AS character indexes, so reconstruct both non-matching and matching AS text values, and calculate accurate AS character ranges from those    � � � ��   i m p o r t a n t :   N S S t r i n g   c h a r a c t e r   i n d e x e s   a r e n ' t   g u a r a n t e e d   t o   b e   s a m e   a s   A S   c h a r a c t e r   i n d e x e s ,   s o   r e c o n s t r u c t   b o t h   n o n - m a t c h i n g   a n d   m a t c h i n g   A S   t e x t   v a l u e s ,   a n d   c a l c u l a t e   a c c u r a t e   A S   c h a r a c t e r   r a n g e s   f r o m   t h o s e �  � � � r        n     I    �a�`�_�a 0 location  �`  �_   o     �^�^  0 asocmatchrange asocMatchRange o      �]�]  0 asocmatchstart asocMatchStart �  r     [    	 o    	�\�\  0 asocmatchstart asocMatchStart	 l  	 
�[�Z
 n  	  I   
 �Y�X�W�Y 
0 length  �X  �W   o   	 
�V�V  0 asocmatchrange asocMatchRange�[  �Z   o      �U�U 0 asocmatchend asocMatchEnd  r     K     �T�T 0 location   o    �S�S  0 asocstartindex asocStartIndex �R�Q�R 
0 length   \     o    �P�P  0 asocmatchstart asocMatchStart o    �O�O  0 asocstartindex asocStartIndex�Q   o      �N�N &0 asocnonmatchrange asocNonMatchRange  r    5 I      �M�L�M $0 _matchinforecord _matchInfoRecord  o    �K�K 0 
asocstring 
asocString  o     �J�J &0 asocnonmatchrange asocNonMatchRange  !  o     !�I�I 0 
textoffset 
textOffset! "�H" o   ! "�G�G (0 nonmatchrecordtype nonMatchRecordType�H  �L   J      ## $%$ o      �F�F 0 nonmatchinfo nonMatchInfo% &�E& o      �D�D 0 
textoffset 
textOffset�E   '(' r   6 N)*) I      �C+�B�C $0 _matchinforecord _matchInfoRecord+ ,-, o   7 8�A�A 0 
asocstring 
asocString- ./. o   8 9�@�@  0 asocmatchrange asocMatchRange/ 010 o   9 :�?�? 0 
textoffset 
textOffset1 2�>2 o   : ;�=�= "0 matchrecordtype matchRecordType�>  �B  * J      33 454 o      �<�< 0 	matchinfo 	matchInfo5 6�;6 o      �:�: 0 
textoffset 
textOffset�;  ( 7�97 L   O V88 J   O U99 :;: o   O P�8�8 0 nonmatchinfo nonMatchInfo; <=< o   P Q�7�7 0 	matchinfo 	matchInfo= >?> o   Q R�6�6 0 asocmatchend asocMatchEnd? @�5@ o   R S�4�4 0 
textoffset 
textOffset�5  �9   � ABA l     �3�2�1�3  �2  �1  B CDC l     �0�/�.�0  �/  �.  D EFE i  + .GHG I      �-I�,�- &0 _matchedgrouplist _matchedGroupListI JKJ o      �+�+ 0 
asocstring 
asocStringK LML o      �*�* 0 	asocmatch 	asocMatchM NON o      �)�) 0 
textoffset 
textOffsetO P�(P o      �'�' &0 includenonmatches includeNonMatches�(  �,  H k     �QQ RSR r     TUT J     �&�&  U o      �%�% "0 submatchresults subMatchResultsS VWV r    XYX \    Z[Z l   
\�$�#\ n   
]^] I    
�"�!� �"  0 numberofranges numberOfRanges�!  �   ^ o    �� 0 	asocmatch 	asocMatch�$  �#  [ m   
 �� Y o      �� 0 groupindexes groupIndexesW _`_ Z    �ab��a ?    cdc o    �� 0 groupindexes groupIndexesd m    ��  b k    �ee fgf r    hih n   jkj I    �l�� 0 rangeatindex_ rangeAtIndex_l m�m m    ��  �  �  k o    �� 0 	asocmatch 	asocMatchi o      �� (0 asocfullmatchrange asocFullMatchRangeg non r    %pqp n   #rsr I    #���� 0 location  �  �  s o    �� (0 asocfullmatchrange asocFullMatchRangeq o      �� &0 asocnonmatchstart asocNonMatchStarto tut r   & /vwv [   & -xyx o   & '�� &0 asocnonmatchstart asocNonMatchStarty l  ' ,z��z n  ' ,{|{ I   ( ,�
�	��
 
0 length  �	  �  | o   ' (�� (0 asocfullmatchrange asocFullMatchRange�  �  w o      �� $0 asocfullmatchend asocFullMatchEndu }~} Y   0 ����� k   : ��� ��� r   : o��� I      ���� 0 _matchrecords _matchRecords� ��� o   ; <�� 0 
asocstring 
asocString� ��� n  < B��� I   = B� ����  0 rangeatindex_ rangeAtIndex_� ���� o   = >���� 0 i  ��  ��  � o   < =���� 0 	asocmatch 	asocMatch� ��� o   B C���� &0 asocnonmatchstart asocNonMatchStart� ��� o   C D���� 0 
textoffset 
textOffset� ��� o   D I���� (0 _unmatchedtexttype _UnmatchedTextType� ���� o   I N���� &0 _matchedgrouptype _MatchedGroupType��  �  � J      �� ��� o      ���� 0 nonmatchinfo nonMatchInfo� ��� o      ���� 0 	matchinfo 	matchInfo� ��� o      ���� &0 asocnonmatchstart asocNonMatchStart� ���� o      ���� 0 
textoffset 
textOffset��  � ��� Z  p |������� o   p q���� &0 includenonmatches includeNonMatches� r   t x��� o   t u���� 0 nonmatchinfo nonMatchInfo� n      ���  ;   v w� o   u v���� "0 submatchresults subMatchResults��  ��  � ���� r   } ���� o   } ~���� 0 	matchinfo 	matchInfo� n      ���  ;    �� o   ~ ���� "0 submatchresults subMatchResults��  � 0 i  � m   3 4���� � o   4 5���� 0 groupindexes groupIndexes�  ~ ���� Z   � �������� o   � ����� &0 includenonmatches includeNonMatches� k   � ��� ��� r   � ���� K   � ��� ������ 0 location  � o   � ����� &0 asocnonmatchstart asocNonMatchStart� ������� 
0 length  � \   � ���� o   � ����� $0 asocfullmatchend asocFullMatchEnd� o   � ����� &0 asocnonmatchstart asocNonMatchStart��  � o      ���� &0 asocnonmatchrange asocNonMatchRange� ���� r   � ���� n   � ���� 4   � ����
�� 
cobj� m   � ����� � I   � �������� $0 _matchinforecord _matchInfoRecord� ��� o   � ����� 0 
asocstring 
asocString� ��� o   � ����� &0 asocnonmatchrange asocNonMatchRange� ��� o   � ����� 0 
textoffset 
textOffset� ���� o   � ����� (0 _unmatchedtexttype _UnmatchedTextType��  ��  � n      ���  ;   � �� o   � ����� "0 submatchresults subMatchResults��  ��  ��  ��  �  �  ` ���� L   � ��� o   � ����� "0 submatchresults subMatchResults��  F ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  / 2��� I      ������� 0 _findpattern _findPattern� ��� o      ���� 0 thetext theText� ��� o      ���� 0 patterntext patternText� ��� o      ���� &0 includenonmatches includeNonMatches� ���� o      ����  0 includematches includeMatches��  ��  � k    �� ��� r     ��� n    ��� I    ������� (0 asbooleanparameter asBooleanParameter� ��� o    ���� &0 includenonmatches includeNonMatches� ���� m    �� ���  u n m a t c h e d   t e x t��  ��  � o     ���� 0 _supportlib _supportLib� o      ���� &0 includenonmatches includeNonMatches� ��� r    ��� n   ��� I    ������� (0 asbooleanparameter asBooleanParameter� ��� o    ����  0 includematches includeMatches� ���� m    �� ���  m a t c h e d   t e x t��  ��  � o    ���� 0 _supportlib _supportLib� o      ����  0 includematches includeMatches� ��� r    $��� I    "������� 60 _compileregularexpression _compileRegularExpression� ���� o    ���� 0 patterntext patternText��  ��  � o      ���� 
0 regexp  � ��� r   % /� � n  % - I   ( -������ &0 stringwithstring_ stringWithString_ �� o   ( )���� 0 thetext theText��  ��   n  % ( o   & (���� 0 nsstring NSString m   % &��
�� misccura  o      ���� 0 
asocstring 
asocString�  l  0 3	
	 r   0 3 m   0 1����   o      ���� &0 asocnonmatchstart asocNonMatchStart
 G A used to calculate NSRanges for non-matching portions of NSString    � �   u s e d   t o   c a l c u l a t e   N S R a n g e s   f o r   n o n - m a t c h i n g   p o r t i o n s   o f   N S S t r i n g  l  4 7 r   4 7 m   4 5����  o      ���� 0 
textoffset 
textOffset B < used to calculate correct AppleScript start and end indexes    � x   u s e d   t o   c a l c u l a t e   c o r r e c t   A p p l e S c r i p t   s t a r t   a n d   e n d   i n d e x e s  r   8 < J   8 :����   o      ���� 0 
resultlist 
resultList  l  = =����   @ : iterate over each non-matched + matched range in NSString    � t   i t e r a t e   o v e r   e a c h   n o n - m a t c h e d   +   m a t c h e d   r a n g e   i n   N S S t r i n g  !  r   = N"#" n  = L$%$ I   > L��&���� @0 matchesinstring_options_range_ matchesInString_options_range_& '(' o   > ?���� 0 
asocstring 
asocString( )*) m   ? @����  * +��+ J   @ H,, -.- m   @ A����  . /��/ n  A F010 I   B F�������� 
0 length  ��  ��  1 o   A B���� 0 
asocstring 
asocString��  ��  ��  % o   = >���� 
0 regexp  # o      ����  0 asocmatcharray asocMatchArray! 232 Y   O �4��56��4 k   _ �77 898 r   _ g:;: l  _ e<����< n  _ e=>= I   ` e��?����  0 objectatindex_ objectAtIndex_? @��@ o   ` a���� 0 i  ��  ��  > o   _ `����  0 asocmatcharray asocMatchArray��  ��  ; o      ���� 0 	asocmatch 	asocMatch9 ABA l  h h��CD��  C � � the first range in match identifies the text matched by the entire pattern, so generate records for full match and its preceding (unmatched) text   D �EE$   t h e   f i r s t   r a n g e   i n   m a t c h   i d e n t i f i e s   t h e   t e x t   m a t c h e d   b y   t h e   e n t i r e   p a t t e r n ,   s o   g e n e r a t e   r e c o r d s   f o r   f u l l   m a t c h   a n d   i t s   p r e c e d i n g   ( u n m a t c h e d )   t e x tB FGF r   h �HIH I      ��J���� 0 _matchrecords _matchRecordsJ KLK o   i j���� 0 
asocstring 
asocStringL MNM n  j pOPO I   k p��Q���� 0 rangeatindex_ rangeAtIndex_Q R��R m   k l����  ��  ��  P o   j k���� 0 	asocmatch 	asocMatchN STS o   p q���� &0 asocnonmatchstart asocNonMatchStartT UVU o   q r�� 0 
textoffset 
textOffsetV WXW o   r w�~�~ (0 _unmatchedtexttype _UnmatchedTextTypeX Y�}Y o   w |�|�| $0 _matchedtexttype _MatchedTextType�}  ��  I J      ZZ [\[ o      �{�{ 0 nonmatchinfo nonMatchInfo\ ]^] o      �z�z 0 	matchinfo 	matchInfo^ _`_ o      �y�y &0 asocnonmatchstart asocNonMatchStart` a�xa o      �w�w 0 
textoffset 
textOffset�x  G bcb Z  � �de�v�ud o   � ��t�t &0 includenonmatches includeNonMatchese r   � �fgf o   � ��s�s 0 nonmatchinfo nonMatchInfog n      hih  ;   � �i o   � ��r�r 0 
resultlist 
resultList�v  �u  c j�qj Z   � �kl�p�ok o   � ��n�n  0 includematches includeMatchesl k   � �mm non l  � ��mpq�m  p any additional ranges in match identify text matched by group references within regexp pattern, e.g. "([0-9]{4})-([0-9]{2})-([0-9]{2})" will match `YYYY-MM-DD` style date strings, returning the entire text match, plus sub-matches representing year, month and day text   q �rr   a n y   a d d i t i o n a l   r a n g e s   i n   m a t c h   i d e n t i f y   t e x t   m a t c h e d   b y   g r o u p   r e f e r e n c e s   w i t h i n   r e g e x p   p a t t e r n ,   e . g .   " ( [ 0 - 9 ] { 4 } ) - ( [ 0 - 9 ] { 2 } ) - ( [ 0 - 9 ] { 2 } ) "   w i l l   m a t c h   ` Y Y Y Y - M M - D D `   s t y l e   d a t e   s t r i n g s ,   r e t u r n i n g   t h e   e n t i r e   t e x t   m a t c h ,   p l u s   s u b - m a t c h e s   r e p r e s e n t i n g   y e a r ,   m o n t h   a n d   d a y   t e x to s�ls r   � �tut b   � �vwv o   � ��k�k 0 	matchinfo 	matchInfow K   � �xx �jy�i�j 0 foundgroups foundGroupsy I   � ��hz�g�h &0 _matchedgrouplist _matchedGroupListz {|{ o   � ��f�f 0 
asocstring 
asocString| }~} o   � ��e�e 0 	asocmatch 	asocMatch~ � n  � ���� o   � ��d�d 0 
startindex 
startIndex� o   � ��c�c 0 	matchinfo 	matchInfo� ��b� o   � ��a�a &0 includenonmatches includeNonMatches�b  �g  �i  u n      ���  ;   � �� o   � ��`�` 0 
resultlist 
resultList�l  �p  �o  �q  �� 0 i  5 m   R S�_�_  6 \   S Z��� l  S X��^�]� n  S X��� I   T X�\�[�Z�\ 	0 count  �[  �Z  � o   S T�Y�Y  0 asocmatcharray asocMatchArray�^  �]  � m   X Y�X�X ��  3 ��� l  � ��W���W  � "  add final non-matched range   � ��� 8   a d d   f i n a l   n o n - m a t c h e d   r a n g e� ��� Z   ����V�U� o   � ��T�T &0 includenonmatches includeNonMatches� k   � �� ��� r   � ���� c   � ���� l  � ���S�R� n  � ���� I   � ��Q��P�Q *0 substringfromindex_ substringFromIndex_� ��O� o   � ��N�N &0 asocnonmatchstart asocNonMatchStart�O  �P  � o   � ��M�M 0 
asocstring 
asocString�S  �R  � m   � ��L
�L 
ctxt� o      �K�K 0 	foundtext 	foundText� ��J� r   � ��� K   � ��� �I��
�I 
pcls� o   � ��H�H (0 _unmatchedtexttype _UnmatchedTextType� �G���G 0 
startindex 
startIndex� o   � ��F�F 0 
textoffset 
textOffset� �E���E 0 endindex endIndex� n   � ���� 1   � ��D
�D 
leng� o   � ��C�C 0 thetext theText� �B��A�B 0 	foundtext 	foundText� o   � ��@�@ 0 	foundtext 	foundText�A  � n      ���  ;   � �� o   � ��?�? 0 
resultlist 
resultList�J  �V  �U  � ��>� L  �� o  �=�= 0 
resultlist 
resultList�>  � ��� l     �<�;�:�<  �;  �:  � ��� l     �9�8�7�9  �8  �7  � ��� l     �6���6  �  -----   � ��� 
 - - - - -� ��� l     �5���5  �   replace pattern   � ���     r e p l a c e   p a t t e r n� ��� l     �4�3�2�4  �3  �2  � ��� i  3 6��� I      �1��0�1 "0 _replacepattern _replacePattern� ��� o      �/�/ 0 thetext theText� ��� o      �.�. 0 patterntext patternText� ��-� o      �,�, 0 templatetext templateText�-  �0  � k     %�� ��� r     
��� n    ��� I    �+��*�+ &0 stringwithstring_ stringWithString_� ��)� o    �(�( 0 thetext theText�)  �*  � n    ��� o    �'�' 0 nsstring NSString� m     �&
�& misccura� o      �%�% 0 
asocstring 
asocString� ��� r    ��� I    �$��#�$ 60 _compileregularexpression _compileRegularExpression� ��"� o    �!�! 0 patterntext patternText�"  �#  � o      � �  
0 regexp  � ��� L    %�� n   $��� I    $���� |0 <stringbyreplacingmatchesinstring_options_range_withtemplate_ <stringByReplacingMatchesInString_options_range_withTemplate_� ��� o    �� 0 
asocstring 
asocString� ��� m    ��  � ��� J    �� ��� m    ��  � ��� n   ��� I    ���� 
0 length  �  �  � o    �� 0 
asocstring 
asocString�  � ��� o     �� 0 templatetext templateText�  �  � o    �� 
0 regexp  �  � ��� l     ����  �  �  � ��� l     ����  �  �  � ��� l     ����  �  -----   � ��� 
 - - - - -� ��� l     �
���
  �  
 find text   � ���    f i n d   t e x t� ��� l     �	���	  �  �  � ��� i  7 :   I      ��� 0 	_findtext 	_findText  o      �� 0 thetext theText  o      �� 0 fortext forText  o      �� &0 includenonmatches includeNonMatches 	�	 o      � �   0 includematches includeMatches�  �   k    '

  l     ����  �� TO DO: is it worth switching to a more efficient algorithim when hypens, punctuation, and white space are all considered and numeric strings ignored (the default)? i.e. given a fixed-length match, the endIndex of a match can be determined using `forText's length + startIndex - 1` instead of measuring the length of all remaining text after `text item i`; will need to implement both approaches and profile them to determine if it makes any significant difference to speed    ��   T O   D O :   i s   i t   w o r t h   s w i t c h i n g   t o   a   m o r e   e f f i c i e n t   a l g o r i t h i m   w h e n   h y p e n s ,   p u n c t u a t i o n ,   a n d   w h i t e   s p a c e   a r e   a l l   c o n s i d e r e d   a n d   n u m e r i c   s t r i n g s   i g n o r e d   ( t h e   d e f a u l t ) ?   i . e .   g i v e n   a   f i x e d - l e n g t h   m a t c h ,   t h e   e n d I n d e x   o f   a   m a t c h   c a n   b e   d e t e r m i n e d   u s i n g   ` f o r T e x t ' s   l e n g t h   +   s t a r t I n d e x   -   1 `   i n s t e a d   o f   m e a s u r i n g   t h e   l e n g t h   o f   a l l   r e m a i n i n g   t e x t   a f t e r   ` t e x t   i t e m   i ` ;   w i l l   n e e d   t o   i m p l e m e n t   b o t h   a p p r o a c h e s   a n d   p r o f i l e   t h e m   t o   d e t e r m i n e   i f   i t   m a k e s   a n y   s i g n i f i c a n t   d i f f e r e n c e   t o   s p e e d  l     ��������  ��  ��    l     Z    ���� =     o     ���� 0 fortext forText m     �   R    ��
�� .ascrerr ****      � **** m     �   � I n v a l i d    f o r    p a r a m e t e r   ( t e x t   i s   e m p t y ,   o r   o n l y   c o n t a i n s   c h a r a c t e r s   i g n o r e d   b y   t h e   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s ) ��!"
�� 
errn! m    	�����Y" ��#��
�� 
erob# o   
 ���� 0 fortext forText��  ��  ��  �� checks if all characters in forText are ignored by current considering/ignoring settings (the alternative would be to return each character as a non-match separated by a zero-length match, but that's probably not what the user intended); note that unlike `aString's length = 0`, which is what library code normally uses to check for empty text, on this occasion we do want to take into account the current considering/ignoring settings so deliberately use `forText is ""` here. For example, when ignoring punctuation, searching for the TID `"!?"` is no different to searching for `""`, because all of its characters are being ignored when comparing the text being searched against the text being searched for. Thus, a simple `forText is ""` test can be used to check in advance if the text contains any matchable characters under the current considering/ignoring settings, and report a meaningful error if not.    �$$   c h e c k s   i f   a l l   c h a r a c t e r s   i n   f o r T e x t   a r e   i g n o r e d   b y   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s   ( t h e   a l t e r n a t i v e   w o u l d   b e   t o   r e t u r n   e a c h   c h a r a c t e r   a s   a   n o n - m a t c h   s e p a r a t e d   b y   a   z e r o - l e n g t h   m a t c h ,   b u t   t h a t ' s   p r o b a b l y   n o t   w h a t   t h e   u s e r   i n t e n d e d ) ;   n o t e   t h a t   u n l i k e   ` a S t r i n g ' s   l e n g t h   =   0 ` ,   w h i c h   i s   w h a t   l i b r a r y   c o d e   n o r m a l l y   u s e s   t o   c h e c k   f o r   e m p t y   t e x t ,   o n   t h i s   o c c a s i o n   w e   d o   w a n t   t o   t a k e   i n t o   a c c o u n t   t h e   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s   s o   d e l i b e r a t e l y   u s e   ` f o r T e x t   i s   " " `   h e r e .   F o r   e x a m p l e ,   w h e n   i g n o r i n g   p u n c t u a t i o n ,   s e a r c h i n g   f o r   t h e   T I D   ` " ! ? " `   i s   n o   d i f f e r e n t   t o   s e a r c h i n g   f o r   ` " " ` ,   b e c a u s e   a l l   o f   i t s   c h a r a c t e r s   a r e   b e i n g   i g n o r e d   w h e n   c o m p a r i n g   t h e   t e x t   b e i n g   s e a r c h e d   a g a i n s t   t h e   t e x t   b e i n g   s e a r c h e d   f o r .   T h u s ,   a   s i m p l e   ` f o r T e x t   i s   " " `   t e s t   c a n   b e   u s e d   t o   c h e c k   i n   a d v a n c e   i f   t h e   t e x t   c o n t a i n s   a n y   m a t c h a b l e   c h a r a c t e r s   u n d e r   t h e   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s ,   a n d   r e p o r t   a   m e a n i n g f u l   e r r o r   i f   n o t . %&% r    '(' J    ����  ( o      ���� 0 
resultlist 
resultList& )*) r    +,+ n   -.- 1    ��
�� 
txdl. 1    ��
�� 
ascr, o      ���� 0 oldtids oldTIDs* /0/ r    #121 o    ���� 0 fortext forText2 n     343 1     "��
�� 
txdl4 1     ��
�� 
ascr0 565 r   $ '787 m   $ %���� 8 o      ���� 0 
startindex 
startIndex6 9:9 r   ( 0;<; n   ( .=>= 1   , .��
�� 
leng> n   ( ,?@? 4   ) ,��A
�� 
citmA m   * +���� @ o   ( )���� 0 thetext theText< o      ���� 0 endindex endIndex: BCB Z   1 JDE��FD B   1 4GHG o   1 2���� 0 
startindex 
startIndexH o   2 3���� 0 endindex endIndexE r   7 DIJI n   7 BKLK 7  8 B��MN
�� 
ctxtM o   < >���� 0 
startindex 
startIndexN o   ? A���� 0 endindex endIndexL o   7 8���� 0 thetext theTextJ o      ���� 0 	foundtext 	foundText��  F r   G JOPO m   G HQQ �RR  P o      ���� 0 	foundtext 	foundTextC STS Z  K fUV����U o   K L���� &0 includenonmatches includeNonMatchesV r   O bWXW K   O _YY ��Z[
�� 
pclsZ o   P U���� (0 _unmatchedtexttype _UnmatchedTextType[ ��\]�� 0 
startindex 
startIndex\ o   V W���� 0 
startindex 
startIndex] ��^_�� 0 endindex endIndex^ o   X Y���� 0 endindex endIndex_ ��`���� 0 	foundtext 	foundText` o   Z [���� 0 	foundtext 	foundText��  X n      aba  ;   ` ab o   _ `���� 0 
resultlist 
resultList��  ��  T cdc Y   ge��fg��e k   whh iji r   w |klk [   w zmnm o   w x���� 0 endindex endIndexn m   x y���� l o      ���� 0 
startindex 
startIndexj opo r   } �qrq \   } �sts l  } �u����u n   } �vwv 1   ~ ���
�� 
lengw o   } ~���� 0 thetext theText��  ��  t l  � �x����x n   � �yzy 1   � ���
�� 
lengz n   � �{|{ 7  � ���}~
�� 
ctxt} l  � ����� 4   � ����
�� 
citm� o   � ����� 0 i  ��  ��  ~ m   � �������| o   � ����� 0 thetext theText��  ��  r o      ���� 0 endindex endIndexp ��� Z   � ������� B   � ���� o   � ����� 0 
startindex 
startIndex� o   � ����� 0 endindex endIndex� r   � ���� n   � ���� 7  � �����
�� 
ctxt� o   � ����� 0 
startindex 
startIndex� o   � ����� 0 endindex endIndex� o   � ����� 0 thetext theText� o      ���� 0 	foundtext 	foundText��  � r   � ���� m   � ��� ���  � o      ���� 0 	foundtext 	foundText� ��� Z  � �������� o   � �����  0 includematches includeMatches� r   � ���� K   � ��� ����
�� 
pcls� o   � ����� $0 _matchedtexttype _MatchedTextType� ������ 0 
startindex 
startIndex� o   � ����� 0 
startindex 
startIndex� ������ 0 endindex endIndex� o   � ����� 0 endindex endIndex� ������ 0 	foundtext 	foundText� o   � ����� 0 	foundtext 	foundText� ������� 0 foundgroups foundGroups� J   � �����  ��  � n      ���  ;   � �� o   � ����� 0 
resultlist 
resultList��  ��  � ��� r   � ���� [   � ���� o   � ����� 0 endindex endIndex� m   � ����� � o      ���� 0 
startindex 
startIndex� ��� r   � ���� \   � ���� [   � ���� o   � ����� 0 
startindex 
startIndex� l  � ������� n   � ���� 1   � ���
�� 
leng� n   � ���� 4   � ����
�� 
citm� o   � ����� 0 i  � o   � ����� 0 thetext theText��  ��  � m   � ����� � o      ���� 0 endindex endIndex� ��� Z   � ������� B   � ���� o   � ����� 0 
startindex 
startIndex� o   � ����� 0 endindex endIndex� r   � ���� n   � ���� 7  � �����
�� 
ctxt� o   � ����� 0 
startindex 
startIndex� o   � ����� 0 endindex endIndex� o   � ����� 0 thetext theText� o      ���� 0 	foundtext 	foundText��  � r   � ���� m   � ��� ���  � o      ���� 0 	foundtext 	foundText� ���� Z  �������� o   � ����� &0 includenonmatches includeNonMatches� r  ��� K  �� ����
�� 
pcls� o  ���� (0 _unmatchedtexttype _UnmatchedTextType� ������ 0 
startindex 
startIndex� o  	
���� 0 
startindex 
startIndex� ������ 0 endindex endIndex� o  ���� 0 endindex endIndex� ������� 0 	foundtext 	foundText� o  ���� 0 	foundtext 	foundText��  � n      ���  ;  � o  �� 0 
resultlist 
resultList��  ��  ��  �� 0 i  f m   j k�~�~ g I  k r�}��|
�} .corecnte****       ****� n   k n��� 2  l n�{
�{ 
citm� o   k l�z�z 0 thetext theText�|  ��  d ��� r  $��� o   �y�y 0 oldtids oldTIDs� n     ��� 1  !#�x
�x 
txdl� 1   !�w
�w 
ascr� ��v� L  %'�� o  %&�u�u 0 
resultlist 
resultList�v  � ��� l     �t�s�r�t  �s  �r  � ��� l     �q�p�o�q  �p  �o  � ��� l     �n���n  �  -----   � ��� 
 - - - - -� ��� l     �m���m  �   replace text   � ���    r e p l a c e   t e x t� ��� l     �l�k�j�l  �k  �j  � ��� i  ; >��� I      �i��h�i 0 _replacetext _replaceText� ��� o      �g�g 0 thetext theText� ��� o      �f�f 0 fortext forText� ��e� o      �d�d 0 newtext newText�e  �h  � k     &�� ��� r        n     1    �c
�c 
txdl 1     �b
�b 
ascr o      �a�a 0 oldtids oldTIDs�  r     o    �`�` 0 fortext forText n     	 1    
�_
�_ 
txdl	 1    �^
�^ 
ascr 

 l    r     n    2   �]
�] 
citm o    �\�\ 0 thetext theText o      �[�[ 0 	textitems 	textItems J D note: TID-based matching uses current considering/ignoring settings    � �   n o t e :   T I D - b a s e d   m a t c h i n g   u s e s   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s  r     o    �Z�Z 0 newtext newText n      1    �Y
�Y 
txdl 1    �X
�X 
ascr  r     c     o    �W�W 0 	textitems 	textItems m    �V
�V 
ctxt o      �U�U 0 
resulttext 
resultText  !  r    #"#" o    �T�T 0 oldtids oldTIDs# n     $%$ 1     "�S
�S 
txdl% 1     �R
�R 
ascr! &�Q& L   $ &'' o   $ %�P�P 0 
resulttext 
resultText�Q  � ()( l     �O�N�M�O  �N  �M  ) *+* l     �L�K�J�L  �K  �J  + ,-, l     �I./�I  .  -----   / �00 
 - - - - -- 121 l     �H�G�F�H  �G  �F  2 343 i  ? B565 I     �E78
�E .Txt:Srchnull���     ctxt7 o      �D�D 0 thetext theText8 �C9:
�C 
For_9 o      �B�B 0 fortext forText: �A;<
�A 
Usin; |�@�?=�>>�@  �?  = o      �=�= 0 matchformat matchFormat�>  > l 
    ?�<�;? l     @�:�9@ m      �8
�8 SerECmpI�:  �9  �<  �;  < �7AB
�7 
ReplA |�6�5C�4D�6  �5  C o      �3�3 0 newtext newText�4  D l     E�2�1E m      �0
�0 
msng�2  �1  B �/F�.
�/ 
RetuF |�-�,G�+H�-  �,  G o      �*�* 0 resultformat resultFormat�+  H l     I�)�(I m      �'
�' RetEMatT�)  �(  �.  6 Q    �JKLJ k   �MM NON r    PQP n   RSR I    �&T�%�& "0 astextparameter asTextParameterT UVU o    	�$�$ 0 thetext theTextV W�#W m   	 
XX �YY  �#  �%  S o    �"�" 0 _supportlib _supportLibQ o      �!�! 0 thetext theTextO Z[Z l   \]^\ r    _`_ n   aba I    � c��  "0 astextparameter asTextParameterc ded o    �� 0 fortext forTexte f�f m    gg �hh  f o r�  �  b o    �� 0 _supportlib _supportLib` o      �� 0 fortext forText] TO DO: when matching with TIDs, optionally accept a list of multiple text values to match? (note:TIDs can do that for free, so it'd just be a case of relaxing restriction on 'for' parameter's type when pattern matching is false to accept a list of text as well); also optionally accept a corresponding list of replacement values for doing mapping? (note that map will need to be O(n) associative list in order to support considering/ignoring, although NSDictionary should be usable when matching case-sensitively)   ^ �ii   T O   D O :   w h e n   m a t c h i n g   w i t h   T I D s ,   o p t i o n a l l y   a c c e p t   a   l i s t   o f   m u l t i p l e   t e x t   v a l u e s   t o   m a t c h ?   ( n o t e : T I D s   c a n   d o   t h a t   f o r   f r e e ,   s o   i t ' d   j u s t   b e   a   c a s e   o f   r e l a x i n g   r e s t r i c t i o n   o n   ' f o r '   p a r a m e t e r ' s   t y p e   w h e n   p a t t e r n   m a t c h i n g   i s   f a l s e   t o   a c c e p t   a   l i s t   o f   t e x t   a s   w e l l ) ;   a l s o   o p t i o n a l l y   a c c e p t   a   c o r r e s p o n d i n g   l i s t   o f   r e p l a c e m e n t   v a l u e s   f o r   d o i n g   m a p p i n g ?   ( n o t e   t h a t   m a p   w i l l   n e e d   t o   b e   O ( n )   a s s o c i a t i v e   l i s t   i n   o r d e r   t o   s u p p o r t   c o n s i d e r i n g / i g n o r i n g ,   a l t h o u g h   N S D i c t i o n a r y   s h o u l d   b e   u s a b l e   w h e n   m a t c h i n g   c a s e - s e n s i t i v e l y )[ jkj Z   3lm��l =    $non n    "pqp 1     "�
� 
lengq o     �� 0 fortext forTexto m   " #��  m R   ' /�rs
� .ascrerr ****      � ****r m   - .tt �uu t I n v a l i d    f o r    p a r a m e t e r   ( e x p e c t e d   o n e   o r   m o r e   c h a r a c t e r s ) .s �vw
� 
errnv m   ) *���Yw �x�
� 
erobx o   + ,�� 0 fortext forText�  �  �  k y�y Z   4�z{�|z =  4 7}~} o   4 5�� 0 newtext newText~ m   5 6�
� 
msng{ l  :�� k   :�� ��� Z   : ������ =  : =��� o   : ;�� 0 resultformat resultFormat� m   ; <�

�
 RetEMatT� r   @ S��� J   @ D�� ��� m   @ A�	
�	 boovfals� ��� m   A B�
� boovtrue�  � J      �� ��� o      �� &0 includenonmatches includeNonMatches� ��� o      ��  0 includematches includeMatches�  � ��� =  V Y��� o   V W�� 0 resultformat resultFormat� m   W X�
� RetEUmaT� ��� r   \ o��� J   \ `�� ��� m   \ ]�
� boovtrue� �� � m   ] ^��
�� boovfals�   � J      �� ��� o      ���� &0 includenonmatches includeNonMatches� ���� o      ����  0 includematches includeMatches��  � ��� =  r u��� o   r s���� 0 resultformat resultFormat� m   s t��
�� RetEAllT� ���� r   x ���� J   x |�� ��� m   x y��
�� boovtrue� ���� m   y z��
�� boovtrue��  � J      �� ��� o      ���� &0 includenonmatches includeNonMatches� ���� o      ����  0 includematches includeMatches��  ��  � n  � ���� I   � �������� >0 throwinvalidparameterconstant throwInvalidParameterConstant� ��� o   � ����� 0 resultformat resultFormat� ���� m   � ��� ���  r e t u r n i n g��  ��  � o   � ����� 0 _supportlib _supportLib� ���� Z   ������ =  � ���� o   � ����� 0 matchformat matchFormat� m   � ���
�� SerECmpI� P   � ����� L   � ��� I   � �������� 0 	_findtext 	_findText� ��� o   � ����� 0 thetext theText� ��� o   � ����� 0 fortext forText� ��� o   � ����� &0 includenonmatches includeNonMatches� ���� o   � �����  0 includematches includeMatches��  ��  � ���
�� consdiac� ���
�� conshyph� ���
�� conspunc� ���
�� conswhit� ����
�� consnume��  � ����
�� conscase��  � ��� =  � ���� o   � ����� 0 matchformat matchFormat� m   � ���
�� SerECmpP� ��� L   � ��� I   � �������� 0 _findpattern _findPattern� ��� o   � ����� 0 thetext theText� ��� o   � ����� 0 fortext forText� ��� o   � ����� &0 includenonmatches includeNonMatches� ���� o   � �����  0 includematches includeMatches��  ��  � ��� =  � ���� o   � ����� 0 matchformat matchFormat� m   � ���
�� SerECmpC� ��� P   � ������ L   � ��� I   � �������� 0 	_findtext 	_findText� ��� o   � ����� 0 thetext theText� ��� o   � ����� 0 fortext forText� ��� o   � ����� &0 includenonmatches includeNonMatches� ���� o   � �����  0 includematches includeMatches��  ��  � ���
�� conscase� ���
�� consdiac� ���
�� conshyph� ���
�� conspunc� ���
�� conswhit� ����
�� consnume��  ��  � ��� =  � ���� o   � ����� 0 matchformat matchFormat� m   � ���
�� SerECmpD� ���� L   � ��� I   � �������� 0 	_findtext 	_findText� � � o   � ����� 0 thetext theText   o   � ����� 0 fortext forText  o   � ����� &0 includenonmatches includeNonMatches �� o   � �����  0 includematches includeMatches��  ��  ��  � n   I  ������ >0 throwinvalidparameterconstant throwInvalidParameterConstant 	
	 o  ���� 0 matchformat matchFormat
 �� m  	 � 
 u s i n g��  ��   o   ���� 0 _supportlib _supportLib��  �   find   � � 
   f i n d�  | l � k  �  r   n  I  ������ "0 astextparameter asTextParameter  o  ���� 0 newtext newText �� m   �  r e p l a c i n g   w i t h��  ��   o  ���� 0 _supportlib _supportLib o      ���� 0 newtext newText �� Z   � !"#  =  %$%$ o   !���� 0 matchformat matchFormat% m  !$��
�� SerECmpI! P  (;&'(& L  1:)) I  19��*���� 0 _replacetext _replaceText* +,+ o  23���� 0 thetext theText, -.- o  34���� 0 fortext forText. /��/ o  45���� 0 newtext newText��  ��  ' ��0
�� consdiac0 ��1
�� conshyph1 ��2
�� conspunc2 ��3
�� conswhit3 ����
�� consnume��  ( ����
�� conscase��  " 454 = >C676 o  >?���� 0 matchformat matchFormat7 m  ?B��
�� SerECmpP5 898 L  FO:: I  FN��;���� "0 _replacepattern _replacePattern; <=< o  GH���� 0 thetext theText= >?> o  HI���� 0 fortext forText? @��@ o  IJ���� 0 newtext newText��  ��  9 ABA = RWCDC o  RS���� 0 matchformat matchFormatD m  SV��
�� SerECmpCB EFE P  ZkGH��G L  ajII I  ai��J���� 0 _replacetext _replaceTextJ KLK o  bc���� 0 thetext theTextL MNM o  cd���� 0 fortext forTextN O��O o  de���� 0 newtext newText��  ��  H ��P
�� conscaseP ��Q
�� consdiacQ ��R
�� conshyphR ��S
�� conspuncS ��T
�� conswhitT ����
�� consnume��  ��  F UVU = nsWXW o  no���� 0 matchformat matchFormatX m  or��
�� SerECmpDV Y��Y L  vZZ I  v~��[��� 0 _replacetext _replaceText[ \]\ o  wx�~�~ 0 thetext theText] ^_^ o  xy�}�} 0 fortext forText_ `�|` o  yz�{�{ 0 newtext newText�|  �  ��  # n ��aba I  ���zc�y�z >0 throwinvalidparameterconstant throwInvalidParameterConstantc ded o  ���x�x 0 matchformat matchFormate f�wf m  ��gg �hh 
 u s i n g�w  �y  b o  ���v�v 0 _supportlib _supportLib��     replace    �ii    r e p l a c e�  K R      �ujk
�u .ascrerr ****      � ****j o      �t�t 0 etext eTextk �slm
�s 
errnl o      �r�r 0 enumber eNumberm �qno
�q 
erobn o      �p�p 0 efrom eFromo �op�n
�o 
errtp o      �m�m 
0 eto eTo�n  L I  ���lq�k�l 
0 _error  q rsr m  ��tt �uu  s e a r c h   t e x ts vwv o  ���j�j 0 etext eTextw xyx o  ���i�i 0 enumber eNumbery z{z o  ���h�h 0 efrom eFrom{ |�g| o  ���f�f 
0 eto eTo�g  �k  4 }~} l     �e�d�c�e  �d  �c  ~ � l     �b�a�`�b  �a  �`  � ��� i  C F��� I     �_��^
�_ .Txt:EPatnull���     ctxt� o      �]�] 0 thetext theText�^  � Q     *���� L    �� c    ��� l   ��\�[� n   ��� I    �Z��Y�Z 40 escapedpatternforstring_ escapedPatternForString_� ��X� l   ��W�V� n   ��� I    �U��T�U "0 astextparameter asTextParameter� ��� o    �S�S 0 thetext theText� ��R� m    �� ���  �R  �T  � o    �Q�Q 0 _supportlib _supportLib�W  �V  �X  �Y  � n   ��� o    �P�P *0 nsregularexpression NSRegularExpression� m    �O
�O misccura�\  �[  � m    �N
�N 
ctxt� R      �M��
�M .ascrerr ****      � ****� o      �L�L 0 etext eText� �K��
�K 
errn� o      �J�J 0 enumber eNumber� �I��
�I 
erob� o      �H�H 0 efrom eFrom� �G��F
�G 
errt� o      �E�E 
0 eto eTo�F  � I     *�D��C�D 
0 _error  � ��� m   ! "�� ���  e s c a p e   p a t t e r n� ��� o   " #�B�B 0 etext eText� ��� o   # $�A�A 0 enumber eNumber� ��� o   $ %�@�@ 0 efrom eFrom� ��?� o   % &�>�> 
0 eto eTo�?  �C  � ��� l     �=�<�;�=  �<  �;  � ��� l     �:�9�8�:  �9  �8  � ��� i  G J��� I     �7��6
�7 .Txt:ETemnull���     ctxt� o      �5�5 0 thetext theText�6  � Q     *���� L    �� c    ��� l   ��4�3� n   ��� I    �2��1�2 60 escapedtemplateforstring_ escapedTemplateForString_� ��0� l   ��/�.� n   ��� I    �-��,�- "0 astextparameter asTextParameter� ��� o    �+�+ 0 thetext theText� ��*� m    �� ���  �*  �,  � o    �)�) 0 _supportlib _supportLib�/  �.  �0  �1  � n   ��� o    �(�( *0 nsregularexpression NSRegularExpression� m    �'
�' misccura�4  �3  � m    �&
�& 
ctxt� R      �%��
�% .ascrerr ****      � ****� o      �$�$ 0 etext eText� �#��
�# 
errn� o      �"�" 0 enumber eNumber� �!��
�! 
erob� o      � �  0 efrom eFrom� ���
� 
errt� o      �� 
0 eto eTo�  � I     *���� 
0 _error  � ��� m   ! "�� ���  e s c a p e   t e m p l a t e� ��� o   " #�� 0 etext eText� ��� o   # $�� 0 enumber eNumber� ��� o   $ %�� 0 efrom eFrom� ��� o   % &�� 
0 eto eTo�  �  � ��� l     ����  �  �  � ��� l     ����  �  �  � ��� l     ����  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ����  �   Conversion Suite   � ��� "   C o n v e r s i o n   S u i t e� ��� l     ����  �  �  � ��� i  K N��� I      �
��	�
 0 	_pinindex 	_pinIndex� ��� o      �� 0 theindex theIndex� ��� o      �� 0 
textlength 
textLength�  �	  � l    %���� Z     %����� ?        o     �� 0 theindex theIndex o    �� 0 
textlength 
textLength� L     o    �� 0 
textlength 
textLength�  A     o    �� 0 theindex theIndex d     o    �� 0 
textlength 
textLength 	 L    

 d     o    � �  0 
textlength 
textLength	  =     o    ���� 0 theindex theIndex m    ����   �� L      m    ���� ��  � L   # % o   # $���� 0 theindex theIndex� i c used by `slice text` to prevent 'out of range' errors (caution: textLength must be greater than 0)   � � �   u s e d   b y   ` s l i c e   t e x t `   t o   p r e v e n t   ' o u t   o f   r a n g e '   e r r o r s   ( c a u t i o n :   t e x t L e n g t h   m u s t   b e   g r e a t e r   t h a n   0 )�  l     ��������  ��  ��    l     ��������  ��  ��    l     ����    -----    � 
 - - - - -  l     ��������  ��  ��     i  O R!"! I     ��#$
�� .Txt:UppTnull���     ctxt# o      ���� 0 thetext theText$ ��%��
�� 
Loca% |����&��'��  ��  & o      ���� 0 
localecode 
localeCode��  ' l     (����( m      ��
�� 
msng��  ��  ��  " Q     N)*+) k    <,, -.- r    /0/ n   121 I    ��3���� &0 stringwithstring_ stringWithString_3 4��4 l   5����5 n   676 I    ��8���� "0 astextparameter asTextParameter8 9:9 o    ���� 0 thetext theText: ;��; m    << �==  ��  ��  7 o    ���� 0 _supportlib _supportLib��  ��  ��  ��  2 n   >?> o    ���� 0 nsstring NSString? m    ��
�� misccura0 o      ���� 0 
asocstring 
asocString. @��@ Z    <AB��CA =   DED o    ���� 0 
localecode 
localeCodeE m    ��
�� 
msngB L    &FF c    %GHG l   #I����I n   #JKJ I    #�������� "0 uppercasestring uppercaseString��  ��  K o    ���� 0 
asocstring 
asocString��  ��  H m   # $��
�� 
ctxt��  C L   ) <LL c   ) ;MNM l  ) 9O����O n  ) 9PQP I   * 9��R���� 80 uppercasestringwithlocale_ uppercaseStringWithLocale_R S��S l  * 5T����T n  * 5UVU I   / 5��W���� &0 aslocaleparameter asLocaleParameterW XYX o   / 0���� 0 
localecode 
localeCodeY Z��Z m   0 1[[ �\\  f o r   l o c a l e��  ��  V o   * /���� 0 _supportlib _supportLib��  ��  ��  ��  Q o   ) *���� 0 
asocstring 
asocString��  ��  N m   9 :��
�� 
ctxt��  * R      ��]^
�� .ascrerr ****      � ****] o      ���� 0 etext eText^ ��_`
�� 
errn_ o      ���� 0 enumber eNumber` ��ab
�� 
eroba o      ���� 0 efrom eFromb ��c��
�� 
errtc o      ���� 
0 eto eTo��  + I   D N��d���� 
0 _error  d efe m   E Fgg �hh  u p p e r c a s e   t e x tf iji o   F G���� 0 etext eTextj klk o   G H���� 0 enumber eNumberl mnm o   H I���� 0 efrom eFromn o��o o   I J���� 
0 eto eTo��  ��    pqp l     ��������  ��  ��  q rsr l     ��������  ��  ��  s tut i  S Vvwv I     ��xy
�� .Txt:CapTnull���     ctxtx o      ���� 0 thetext theTexty ��z��
�� 
Locaz |����{��|��  ��  { o      ���� 0 
localecode 
localeCode��  | l     }����} m      ��
�� 
msng��  ��  ��  w Q     N~�~ k    <�� ��� r    ��� n   ��� I    ������� &0 stringwithstring_ stringWithString_� ���� l   ������ n   ��� I    ������� "0 astextparameter asTextParameter� ��� o    ���� 0 thetext theText� ���� m    �� ���  ��  ��  � o    ���� 0 _supportlib _supportLib��  ��  ��  ��  � n   ��� o    ���� 0 nsstring NSString� m    ��
�� misccura� o      ���� 0 
asocstring 
asocString� ���� Z    <������ =   ��� o    ���� 0 
localecode 
localeCode� m    ��
�� 
msng� L    &�� c    %��� l   #������ n   #��� I    #�������� &0 capitalizedstring capitalizedString��  ��  � o    ���� 0 
asocstring 
asocString��  ��  � m   # $��
�� 
ctxt��  � L   ) <�� c   ) ;��� l  ) 9������ n  ) 9��� I   * 9������� <0 capitalizedstringwithlocale_ capitalizedStringWithLocale_� ���� l  * 5������ n  * 5��� I   / 5���~� &0 aslocaleparameter asLocaleParameter� ��� o   / 0�}�} 0 
localecode 
localeCode� ��|� m   0 1�� ���  f o r   l o c a l e�|  �~  � o   * /�{�{ 0 _supportlib _supportLib��  ��  ��  ��  � o   ) *�z�z 0 
asocstring 
asocString��  ��  � m   9 :�y
�y 
ctxt��   R      �x��
�x .ascrerr ****      � ****� o      �w�w 0 etext eText� �v��
�v 
errn� o      �u�u 0 enumber eNumber� �t��
�t 
erob� o      �s�s 0 efrom eFrom� �r��q
�r 
errt� o      �p�p 
0 eto eTo�q  � I   D N�o��n�o 
0 _error  � ��� m   E F�� ���  c a p i t a l i z e   t e x t� ��� o   F G�m�m 0 etext eText� ��� o   G H�l�l 0 enumber eNumber� ��� o   H I�k�k 0 efrom eFrom� ��j� o   I J�i�i 
0 eto eTo�j  �n  u ��� l     �h�g�f�h  �g  �f  � ��� l     �e�d�c�e  �d  �c  � ��� i  W Z��� I     �b��
�b .Txt:LowTnull���     ctxt� o      �a�a 0 thetext theText� �`��_
�` 
Loca� |�^�]��\��^  �]  � o      �[�[ 0 
localecode 
localeCode�\  � l     ��Z�Y� m      �X
�X 
msng�Z  �Y  �_  � Q     N���� k    <�� ��� r    ��� n   ��� I    �W��V�W &0 stringwithstring_ stringWithString_� ��U� l   ��T�S� n   ��� I    �R��Q�R "0 astextparameter asTextParameter� ��� o    �P�P 0 thetext theText� ��O� m    �� ���  �O  �Q  � o    �N�N 0 _supportlib _supportLib�T  �S  �U  �V  � n   ��� o    �M�M 0 nsstring NSString� m    �L
�L misccura� o      �K�K 0 
asocstring 
asocString� ��J� Z    <���I�� =   ��� o    �H�H 0 
localecode 
localeCode� m    �G
�G 
msng� L    &�� c    %��� l   #��F�E� n   #��� I    #�D�C�B�D "0 lowercasestring lowercaseString�C  �B  � o    �A�A 0 
asocstring 
asocString�F  �E  � m   # $�@
�@ 
ctxt�I  � L   ) <�� c   ) ;��� l  ) 9��?�>� n  ) 9��� I   * 9�=��<�= 80 lowercasestringwithlocale_ lowercaseStringWithLocale_� ��;� l  * 5��:�9� n  * 5� � I   / 5�8�7�8 &0 aslocaleparameter asLocaleParameter  o   / 0�6�6 0 
localecode 
localeCode �5 m   0 1 �  f o r   l o c a l e�5  �7    o   * /�4�4 0 _supportlib _supportLib�:  �9  �;  �<  � o   ) *�3�3 0 
asocstring 
asocString�?  �>  � m   9 :�2
�2 
ctxt�J  � R      �1
�1 .ascrerr ****      � **** o      �0�0 0 etext eText �/	

�/ 
errn	 o      �.�. 0 enumber eNumber
 �-
�- 
erob o      �,�, 0 efrom eFrom �+�*
�+ 
errt o      �)�) 
0 eto eTo�*  � I   D N�(�'�( 
0 _error    m   E F �  l o w e r c a s e   t e x t  o   F G�&�& 0 etext eText  o   G H�%�% 0 enumber eNumber  o   H I�$�$ 0 efrom eFrom �# o   I J�"�" 
0 eto eTo�#  �'  �  l     �!� ��!  �   �    l     ����  �  �    i  [ ^ !  I     �"#
� .Txt:PadTnull���     ctxt" o      �� 0 thetext theText# �$%
� 
toPl$ o      �� 0 toplaces toPlaces% �&'
� 
Char& |��(�)�  �  ( o      �� 0 padchar padChar�  ) m      ** �++   ' �,�
� 
From, |��-�.�  �  - o      �� 0 whichend whichEnd�  . l     /��/ m      �

�
 LeTrLCha�  �  �  ! k     �00 121 l     �	34�	  3 � � TO DO: what if pad is multi-char? how best to align on right? e.g. if pad is ". " then ideally the periods should always appear in same columns, e.g. "foo. . ." vs "food . ."   4 �55^   T O   D O :   w h a t   i f   p a d   i s   m u l t i - c h a r ?   h o w   b e s t   t o   a l i g n   o n   r i g h t ?   e . g .   i f   p a d   i s   " .   "   t h e n   i d e a l l y   t h e   p e r i o d s   s h o u l d   a l w a y s   a p p e a r   i n   s a m e   c o l u m n s ,   e . g .   " f o o .   .   . "   v s   " f o o d   .   . "2 6�6 Q     �7897 k    �:: ;<; r    =>= n   ?@? I    �A�� "0 astextparameter asTextParameterA BCB o    	�� 0 thetext theTextC D�D m   	 
EE �FF  �  �  @ o    �� 0 _supportlib _supportLib> o      �� 0 thetext theText< GHG r    IJI n   KLK I    �M� � (0 asintegerparameter asIntegerParameterM NON o    ���� 0 toplaces toPlacesO P��P m    QQ �RR  t o   p l a c e s��  �   L o    ���� 0 _supportlib _supportLibJ o      ���� 0 toplaces toPlacesH STS r    &UVU \    $WXW o     ���� 0 toplaces toPlacesX l    #Y����Y n    #Z[Z 1   ! #��
�� 
leng[ o     !���� 0 thetext theText��  ��  V o      ���� 0 	charcount 	charCountT \]\ Z  ' 3^_����^ B   ' *`a` o   ' (���� 0 	charcount 	charCounta m   ( )����  _ L   - /bb o   - .���� 0 thetext theText��  ��  ] cdc r   4 Aefe n  4 ?ghg I   9 ?��i���� "0 astextparameter asTextParameteri jkj o   9 :���� 0 padchar padChark l��l m   : ;mm �nn 
 u s i n g��  ��  h o   4 9���� 0 _supportlib _supportLibf o      ���� 0 padtext padTextd opo Z  B Vqr����q =   B Gsts n  B Euvu 1   C E��
�� 
lengv o   B C���� 0 padtext padTextt m   E F����  r R   J R��wx
�� .ascrerr ****      � ****w m   P Qyy �zz f I n v a l i d    u s i n g    p a r a m e t e r   ( e m p t y   t e x t   n o t   a l l o w e d ) .x ��{|
�� 
errn{ m   L M�����Y| ��}��
�� 
erob} o   N O���� 0 padchar padChar��  ��  ��  p ~~ V   W k��� r   a f��� b   a d��� o   a b���� 0 padtext padText� o   b c���� 0 padtext padText� o      ���� 0 padtext padText� A   [ `��� n  [ ^��� 1   \ ^��
�� 
leng� o   [ \���� 0 padtext padText� o   ^ _���� 0 	charcount 	charCount ���� Z   l ������ =  l o��� o   l m���� 0 whichend whichEnd� m   m n��
�� LeTrLCha� L   r ��� b   r ��� l  r }������ n  r }��� 7  s }����
�� 
ctxt� m   w y���� � o   z |���� 0 	charcount 	charCount� o   r s���� 0 padtext padText��  ��  � o   } ~���� 0 thetext theText� ��� =  � ���� o   � ����� 0 whichend whichEnd� m   � ���
�� LeTrTCha� ��� L   � ��� b   � ���� o   � ����� 0 thetext theText� l  � ������� n  � ���� 7  � �����
�� 
ctxt� m   � ����� � o   � ����� 0 	charcount 	charCount� o   � ����� 0 padtext padText��  ��  � ��� =  � ���� o   � ����� 0 whichend whichEnd� m   � ���
�� LeTrBCha� ���� Z   � ������� =   � ���� o   � ����� 0 	charcount 	charCount� m   � ����� � L   � ��� b   � ���� o   � ����� 0 thetext theText� l  � ������� n  � ���� 7  � �����
�� 
ctxt� m   � ����� � o   � ����� 0 	charcount 	charCount� o   � ����� 0 padtext padText��  ��  ��  � L   � ��� n  � ���� 7  � �����
�� 
ctxt� m   � ����� � o   � ����� 0 toplaces toPlaces� l  � ������� b   � ���� b   � ���� n  � ���� 7  � �����
�� 
ctxt� m   � ����� � l  � ������� _   � ���� o   � ����� 0 	charcount 	charCount� m   � ����� ��  ��  � o   � ����� 0 padtext padText� o   � ����� 0 thetext theText� o   � ����� 0 padtext padText��  ��  ��  � n  � ���� I   � �������� >0 throwinvalidparameterconstant throwInvalidParameterConstant� ��� o   � ����� 0 whichend whichEnd� ���� m   � ��� ���  a d d i n g��  ��  � o   � ����� 0 _supportlib _supportLib��  8 R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  9 I   � �������� 
0 _error  � ��� m   � ��� ���  p a d   t e x t� ��� o   � ����� 0 etext eText� ��� o   � ����� 0 enumber eNumber� ��� o   � ����� 0 efrom eFrom� ���� o   � ����� 
0 eto eTo��  ��  �   ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  _ b��� I     ����
�� .Txt:SliTnull���     ctxt� o      ���� 0 thetext theText� ����
�� 
Idx1� |����������  ��  � o      ���� 0 
startindex 
startIndex��  � m      ���� � �����
�� 
Idx2� |����������  ��  � o      ���� 0 endindex endIndex��  � d      �� m      ���� ��  � Q     k���� k    Y�� ��� r    ��� n   � � I    ������ "0 astextparameter asTextParameter  o    	�� 0 thetext theText �~ m   	 
 �  �~  ��    o    �}�} 0 _supportlib _supportLib� o      �|�| 0 thetext theText�  l   	
	 Z   �{�z =     n    1    �y
�y 
leng o    �x�x 0 thetext theText m    �w�w   L     m     �  �{  �z  

 caution: testing for `theText is ""` is dependent on current considering/ignoring settings, thus, the only safe ways to check for an empty/non-empty string are to 1. count its characters, or 2. wrap it in a `considering hyphens, punctuation, and white space` block     �   c a u t i o n :   t e s t i n g   f o r   ` t h e T e x t   i s   " " `   i s   d e p e n d e n t   o n   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s ,   t h u s ,   t h e   o n l y   s a f e   w a y s   t o   c h e c k   f o r   a n   e m p t y / n o n - e m p t y   s t r i n g   a r e   t o   1 .   c o u n t   i t s   c h a r a c t e r s ,   o r   2 .   w r a p   i t   i n   a   ` c o n s i d e r i n g   h y p h e n s ,   p u n c t u a t i o n ,   a n d   w h i t e   s p a c e `   b l o c k    l     �v�u�t�v  �u  �t    l     �s�s   � � TO DO: what if startindex comes after endindex? swap them and return text range as normal, or return empty text? (could even return the specified text range with the characters reversed, but I suspect that won't be helpful)    ��   T O   D O :   w h a t   i f   s t a r t i n d e x   c o m e s   a f t e r   e n d i n d e x ?   s w a p   t h e m   a n d   r e t u r n   t e x t   r a n g e   a s   n o r m a l ,   o r   r e t u r n   e m p t y   t e x t ?   ( c o u l d   e v e n   r e t u r n   t h e   s p e c i f i e d   t e x t   r a n g e   w i t h   t h e   c h a r a c t e r s   r e v e r s e d ,   b u t   I   s u s p e c t   t h a t   w o n ' t   b e   h e l p f u l )  l     �r�q�p�r  �q  �p     l     �o!"�o  ! � � TO DO: if the entire slice is out of range (i.e. *both* indexes are before or after the first/last character) then need to return "" (currently, because of how it pins, it'll return a single character instead, which is incorrect)   " �##�   T O   D O :   i f   t h e   e n t i r e   s l i c e   i s   o u t   o f   r a n g e   ( i . e .   * b o t h *   i n d e x e s   a r e   b e f o r e   o r   a f t e r   t h e   f i r s t / l a s t   c h a r a c t e r )   t h e n   n e e d   t o   r e t u r n   " "   ( c u r r e n t l y ,   b e c a u s e   o f   h o w   i t   p i n s ,   i t ' l l   r e t u r n   a   s i n g l e   c h a r a c t e r   i n s t e a d ,   w h i c h   i s   i n c o r r e c t )  $%$ r     5&'& I     3�n(�m�n 0 	_pinindex 	_pinIndex( )*) n  ! ,+,+ I   & ,�l-�k�l (0 asintegerparameter asIntegerParameter- ./. o   & '�j�j 0 
startindex 
startIndex/ 0�i0 m   ' (11 �22  f r o m�i  �k  , o   ! &�h�h 0 _supportlib _supportLib* 3�g3 n   , /454 1   - /�f
�f 
leng5 o   , -�e�e 0 thetext theText�g  �m  ' o      �d�d 0 
startindex 
startIndex% 676 r   6 K898 I   6 I�c:�b�c 0 	_pinindex 	_pinIndex: ;<; n  7 B=>= I   < B�a?�`�a (0 asintegerparameter asIntegerParameter? @A@ o   < =�_�_ 0 endindex endIndexA B�^B m   = >CC �DD  t o�^  �`  > o   7 <�]�] 0 _supportlib _supportLib< E�\E n   B EFGF 1   C E�[
�[ 
lengG o   B C�Z�Z 0 thetext theText�\  �b  9 o      �Y�Y 0 endindex endIndex7 H�XH L   L YII n   L XJKJ 7  M W�WLM
�W 
ctxtL o   Q S�V�V 0 
startindex 
startIndexM o   T V�U�U 0 endindex endIndexK o   L M�T�T 0 thetext theText�X  � R      �SNO
�S .ascrerr ****      � ****N o      �R�R 0 etext eTextO �QPQ
�Q 
errnP o      �P�P 0 enumber eNumberQ �ORS
�O 
erobR o      �N�N 0 efrom eFromS �MT�L
�M 
errtT o      �K�K 
0 eto eTo�L  � I   a k�JU�I�J 
0 _error  U VWV m   b cXX �YY  s l i c e   t e x tW Z[Z o   c d�H�H 0 etext eText[ \]\ o   d e�G�G 0 enumber eNumber] ^_^ o   e f�F�F 0 efrom eFrom_ `�E` o   f g�D�D 
0 eto eTo�E  �I  � aba l     �C�B�A�C  �B  �A  b cdc l     �@�?�>�@  �?  �>  d efe i  c fghg I     �=ij
�= .Txt:TrmTnull���     ctxti o      �<�< 0 thetext theTextj �;k�:
�; 
Fromk |�9�8l�7m�9  �8  l o      �6�6 0 whichend whichEnd�7  m l     n�5�4n m      �3
�3 LeTrBCha�5  �4  �:  h Q     �opqo k    �rr sts r    uvu n   wxw I    �2y�1�2 "0 astextparameter asTextParametery z{z o    	�0�0 0 thetext theText{ |�/| m   	 
}} �~~  �/  �1  x o    �.�. 0 _supportlib _supportLibv o      �-�- 0 thetext theTextt � Z    -���,�+� H    �� E   ��� J    �� ��� m    �*
�* LeTrLCha� ��� m    �)
�) LeTrTCha� ��(� m    �'
�' LeTrBCha�(  � J    �� ��&� o    �%�% 0 whichend whichEnd�&  � n   )��� I   # )�$��#�$ >0 throwinvalidparameterconstant throwInvalidParameterConstant� ��� o   # $�"�" 0 whichend whichEnd� ��!� m   $ %�� ���  r e m o v i n g�!  �#  � o    #� �  0 _supportlib _supportLib�,  �+  � ��� P   . ����� k   3 ��� ��� l  3 ?���� Z  3 ?����� =  3 6��� o   3 4�� 0 thetext theText� m   4 5�� ���  � L   9 ;�� m   9 :�� ���  �  �  � H B check if theText is empty or contains white space characters only   � ��� �   c h e c k   i f   t h e T e x t   i s   e m p t y   o r   c o n t a i n s   w h i t e   s p a c e   c h a r a c t e r s   o n l y� ��� r   @ S��� J   @ D�� ��� m   @ A�� � ��� m   A B�����  � J      �� ��� o      �� 0 
startindex 
startIndex� ��� o      �� 0 endindex endIndex�  � ��� Z   T x����� E  T \��� J   T X�� ��� m   T U�
� LeTrLCha� ��� m   U V�
� LeTrBCha�  � J   X [�� ��� o   X Y�� 0 whichend whichEnd�  � V   _ t��� r   j o��� [   j m��� o   j k�� 0 
startindex 
startIndex� m   k l�� � o      �� 0 
startindex 
startIndex� =  c i��� n   c g��� 4   d g��
� 
cha � o   e f�
�
 0 
startindex 
startIndex� o   c d�	�	 0 thetext theText� m   g h�� ���  �  �  � ��� Z   y ������ E  y ���� J   y }�� ��� m   y z�
� LeTrTCha� ��� m   z {�
� LeTrBCha�  � J   } ��� ��� o   } ~�� 0 whichend whichEnd�  � V   � ���� r   � ���� \   � ���� o   � ��� 0 endindex endIndex� m   � �� �  � o      ���� 0 endindex endIndex� =  � ���� n   � ���� 4   � ����
�� 
cha � o   � ����� 0 endindex endIndex� o   � ����� 0 thetext theText� m   � ��� ���  �  �  � ���� L   � ��� n   � ���� 7  � �����
�� 
ctxt� o   � ����� 0 
startindex 
startIndex� o   � ����� 0 endindex endIndex� o   � ����� 0 thetext theText��  � ���
�� conscase� ���
�� consdiac� ���
�� conshyph� ����
�� conspunc��  � ���
�� consnume� ����
�� conswhit��  �  p R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  q I   � �������� 
0 _error  � ��� m   � ��� ���  t r i m   t e x t� ��� o   � ����� 0 etext eText� 	 		  o   � ����� 0 enumber eNumber	 			 o   � ����� 0 efrom eFrom	 	��	 o   � ����� 
0 eto eTo��  ��  f 			 l     ��������  ��  ��  	 			 l     ��������  ��  ��  	 			
		 l     ��		��  	 J D--------------------------------------------------------------------   	 �		 � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -	
 			 l     ��		��  	   Split and Join Suite   	 �		 *   S p l i t   a n d   J o i n   S u i t e	 			 l     ��������  ��  ��  	 			 i  g j			 I      ��	���� 0 
_splittext 
_splitText	 			 o      ���� 0 thetext theText	 	��	 o      ���� 0 theseparator theSeparator��  ��  	 l    ^				 k     ^	 	  	!	"	! r     	#	$	# n    
	%	&	% I    
��	'���� "0 aslistparameter asListParameter	' 	(��	( o    ���� 0 theseparator theSeparator��  ��  	& o     ���� 0 _supportlib _supportLib	$ o      ���� 0 delimiterlist delimiterList	" 	)	*	) X    C	+��	,	+ Q    >	-	.	/	- l    )	0	1	2	0 r     )	3	4	3 c     %	5	6	5 n     #	7	8	7 1   ! #��
�� 
pcnt	8 o     !���� 0 aref aRef	6 m   # $��
�� 
ctxt	4 n      	9	:	9 1   & (��
�� 
pcnt	: o   % &���� 0 aref aRef	1�� caution: AS silently ignores invalid TID values, so separator items must be explicitly validated to catch any user errors; for now, just coerce to text and catch errors, but might want to make it more rigorous in future (e.g. if a list of lists is given, should sublist be treated as an error instead of just coercing it to text, which is itself TIDs sensitive); see also existing TODO on LibrarySupportLib's asTextParameter handler   	2 �	;	;b   c a u t i o n :   A S   s i l e n t l y   i g n o r e s   i n v a l i d   T I D   v a l u e s ,   s o   s e p a r a t o r   i t e m s   m u s t   b e   e x p l i c i t l y   v a l i d a t e d   t o   c a t c h   a n y   u s e r   e r r o r s ;   f o r   n o w ,   j u s t   c o e r c e   t o   t e x t   a n d   c a t c h   e r r o r s ,   b u t   m i g h t   w a n t   t o   m a k e   i t   m o r e   r i g o r o u s   i n   f u t u r e   ( e . g .   i f   a   l i s t   o f   l i s t s   i s   g i v e n ,   s h o u l d   s u b l i s t   b e   t r e a t e d   a s   a n   e r r o r   i n s t e a d   o f   j u s t   c o e r c i n g   i t   t o   t e x t ,   w h i c h   i s   i t s e l f   T I D s   s e n s i t i v e ) ;   s e e   a l s o   e x i s t i n g   T O D O   o n   L i b r a r y S u p p o r t L i b ' s   a s T e x t P a r a m e t e r   h a n d l e r	. R      ����	<
�� .ascrerr ****      � ****��  	< ��	=��
�� 
errn	= d      	>	> m      �������  	/ l  1 >	?	@	A	? n  1 >	B	C	B I   6 >��	D���� 60 throwinvalidparametertype throwInvalidParameterType	D 	E	F	E o   6 7���� 0 theseparator theSeparator	F 	G	H	G m   7 8	I	I �	J	J  u s i n g   s e p a r a t o r	H 	K	L	K m   8 9	M	M �	N	N  l i s t   o f   t e x t	L 	O��	O m   9 :��
�� 
list��  ��  	C o   1 6���� 0 _supportlib _supportLib	@ � TO DO: would it be better to return a reference to the invalid item rather than the entire list? note that ListLib uses `a ref to item INDEX of LIST` for `eFrom`, which makes the problem value obvious (also, what to use for `eTo` as `list` is vague?)   	A �	P	P�   T O   D O :   w o u l d   i t   b e   b e t t e r   t o   r e t u r n   a   r e f e r e n c e   t o   t h e   i n v a l i d   i t e m   r a t h e r   t h a n   t h e   e n t i r e   l i s t ?   n o t e   t h a t   L i s t L i b   u s e s   ` a   r e f   t o   i t e m   I N D E X   o f   L I S T `   f o r   ` e F r o m ` ,   w h i c h   m a k e s   t h e   p r o b l e m   v a l u e   o b v i o u s   ( a l s o ,   w h a t   t o   u s e   f o r   ` e T o `   a s   ` l i s t `   i s   v a g u e ? )�� 0 aref aRef	, o    ���� 0 delimiterlist delimiterList	* 	Q	R	Q r   D I	S	T	S n  D G	U	V	U 1   E G��
�� 
txdl	V 1   D E��
�� 
ascr	T o      ���� 0 oldtids oldTIDs	R 	W	X	W r   J O	Y	Z	Y o   J K���� 0 delimiterlist delimiterList	Z n     	[	\	[ 1   L N��
�� 
txdl	\ 1   K L��
�� 
ascr	X 	]	^	] r   P U	_	`	_ n   P S	a	b	a 2  Q S��
�� 
citm	b o   P Q���� 0 thetext theText	` o      ���� 0 
resultlist 
resultList	^ 	c	d	c r   V [	e	f	e o   V W���� 0 oldtids oldTIDs	f n     	g	h	g 1   X Z��
�� 
txdl	h 1   W X��
�� 
ascr	d 	i��	i L   \ ^	j	j o   \ ]���� 0 
resultlist 
resultList��  	 � � used by `split text` to split text using one or more text item delimiters and current or predefined considering/ignoring settings   	 �	k	k   u s e d   b y   ` s p l i t   t e x t `   t o   s p l i t   t e x t   u s i n g   o n e   o r   m o r e   t e x t   i t e m   d e l i m i t e r s   a n d   c u r r e n t   o r   p r e d e f i n e d   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s	 	l	m	l l     ��������  ��  ��  	m 	n	o	n l     ��������  ��  ��  	o 	p	q	p i  k n	r	s	r I      ��	t���� 0 _splitpattern _splitPattern	t 	u	v	u o      ���� 0 thetext theText	v 	w��	w o      ���� 0 patterntext patternText��  ��  	s l    �	x	y	z	x k     �	{	{ 	|	}	| r     	~		~ I     ��	����� 60 _compileregularexpression _compileRegularExpression	� 	���	� o    ���� 0 patterntext patternText��  ��  	 o      ���� 
0 regexp  	} 	�	�	� r   	 	�	�	� n  	 	�	�	� I    ��	����� &0 stringwithstring_ stringWithString_	� 	���	� o    ���� 0 thetext theText��  ��  	� n  	 	�	�	� o   
 ���� 0 nsstring NSString	� m   	 
��
�� misccura	� o      ���� 0 
asocstring 
asocString	� 	�	�	� l   	�	�	�	� r    	�	�	� m    ����  	� o      ���� &0 asocnonmatchstart asocNonMatchStart	� G A used to calculate NSRanges for non-matching portions of NSString   	� �	�	� �   u s e d   t o   c a l c u l a t e   N S R a n g e s   f o r   n o n - m a t c h i n g   p o r t i o n s   o f   N S S t r i n g	� 	�	�	� r    	�	�	� J    ����  	� o      ���� 0 
resultlist 
resultList	� 	�	�	� l   ��	�	���  	� @ : iterate over each non-matched + matched range in NSString   	� �	�	� t   i t e r a t e   o v e r   e a c h   n o n - m a t c h e d   +   m a t c h e d   r a n g e   i n   N S S t r i n g	� 	�	�	� r    .	�	�	� n   ,	�	�	� I    ,��	����� @0 matchesinstring_options_range_ matchesInString_options_range_	� 	�	�	� o    ���� 0 
asocstring 
asocString	� 	�	�	� m     ����  	� 	���	� J     (	�	� 	�	�	� m     !����  	� 	���	� n  ! &	�	�	� I   " &�������� 
0 length  ��  ��  	� o   ! "���� 0 
asocstring 
asocString��  ��  ��  	� o    ���� 
0 regexp  	� o      ����  0 asocmatcharray asocMatchArray	� 	�	�	� Y   / v	��	�	��~	� k   ? q	�	� 	�	�	� r   ? L	�	�	� l  ? J	��}�|	� n  ? J	�	�	� I   E J�{	��z�{ 0 rangeatindex_ rangeAtIndex_	� 	��y	� m   E F�x�x  �y  �z  	� l  ? E	��w�v	� n  ? E	�	�	� I   @ E�u	��t�u  0 objectatindex_ objectAtIndex_	� 	��s	� o   @ A�r�r 0 i  �s  �t  	� o   ? @�q�q  0 asocmatcharray asocMatchArray�w  �v  �}  �|  	� o      �p�p  0 asocmatchrange asocMatchRange	� 	�	�	� r   M T	�	�	� n  M R	�	�	� I   N R�o�n�m�o 0 location  �n  �m  	� o   M N�l�l  0 asocmatchrange asocMatchRange	� o      �k�k  0 asocmatchstart asocMatchStart	� 	�	�	� r   U g	�	�	� c   U d	�	�	� l  U b	��j�i	� n  U b	�	�	� I   V b�h	��g�h *0 substringwithrange_ substringWithRange_	� 	��f	� K   V ^	�	� �e	�	��e 0 location  	� o   W X�d�d &0 asocnonmatchstart asocNonMatchStart	� �c	��b�c 
0 length  	� \   Y \	�	�	� o   Y Z�a�a  0 asocmatchstart asocMatchStart	� o   Z [�`�` &0 asocnonmatchstart asocNonMatchStart�b  �f  �g  	� o   U V�_�_ 0 
asocstring 
asocString�j  �i  	� m   b c�^
�^ 
ctxt	� n      	�	�	�  ;   e f	� o   d e�]�] 0 
resultlist 
resultList	� 	��\	� r   h q	�	�	� [   h o	�	�	� o   h i�[�[  0 asocmatchstart asocMatchStart	� l  i n	��Z�Y	� n  i n	�	�	� I   j n�X�W�V�X 
0 length  �W  �V  	� o   i j�U�U  0 asocmatchrange asocMatchRange�Z  �Y  	� o      �T�T &0 asocnonmatchstart asocNonMatchStart�\  � 0 i  	� m   2 3�S�S  	� \   3 :	�	�	� l  3 8	��R�Q	� n  3 8	�	�	� I   4 8�P�O�N�P 	0 count  �O  �N  	� o   3 4�M�M  0 asocmatcharray asocMatchArray�R  �Q  	� m   8 9�L�L �~  	� 	�	�	� l  w w�K	�	��K  	� "  add final non-matched range   	� �	�	� 8   a d d   f i n a l   n o n - m a t c h e d   r a n g e	� 	�	�	� r   w �	�	�	� c   w 	�	�	� l  w }	��J�I	� n  w }	�	�	� I   x }�H	��G�H *0 substringfromindex_ substringFromIndex_	� 	��F	� o   x y�E�E &0 asocnonmatchstart asocNonMatchStart�F  �G  	� o   w x�D�D 0 
asocstring 
asocString�J  �I  	� m   } ~�C
�C 
ctxt	� n      	�	�	�  ;   � �	� o    ��B�B 0 
resultlist 
resultList	� 	��A	� L   � �	�	� o   � ��@�@ 0 
resultlist 
resultList�A  	y Q K used by `split text` to split text using a regular expression as separator   	z �	�	� �   u s e d   b y   ` s p l i t   t e x t `   t o   s p l i t   t e x t   u s i n g   a   r e g u l a r   e x p r e s s i o n   a s   s e p a r a t o r	q 	�	�	� l     �?�>�=�?  �>  �=  	� 
 

  l     �<�;�:�<  �;  �:  
 


 i  o r


 I      �9
�8�9 0 	_jointext 	_joinText
 


 o      �7�7 0 thelist theList
 
	�6
	 o      �5�5 0 separatortext separatorText�6  �8  
 k     >



 


 r     


 n    


 1    �4
�4 
txdl
 1     �3
�3 
ascr
 o      �2�2 0 oldtids oldTIDs
 


 r    


 o    �1�1 0 delimiterlist delimiterList
 n     


 1    
�0
�0 
txdl
 1    �/
�/ 
ascr
 


 Q    5



 r    


 c    


 n   
 
!
  I    �.
"�-�. "0 aslistparameter asListParameter
" 
#�,
# o    �+�+ 0 thelist theList�,  �-  
! o    �*�* 0 _supportlib _supportLib
 m    �)
�) 
ctxt
 o      �(�( 0 
resulttext 
resultText
 R      �'�&
$
�' .ascrerr ****      � ****�&  
$ �%
%�$
�% 
errn
% d      
&
& m      �#�#��$  
 k   % 5
'
' 
(
)
( r   % *
*
+
* o   % &�"�" 0 oldtids oldTIDs
+ n     
,
-
, 1   ' )�!
�! 
txdl
- 1   & '� 
�  
ascr
) 
.�
. R   + 5�
/
0
� .ascrerr ****      � ****
/ m   3 4
1
1 �
2
2 b I n v a l i d   d i r e c t   p a r a m e t e r   ( e x p e c t e d   l i s t   o f   t e x t ) .
0 �
3
4
� 
errn
3 m   - .���Y
4 �
5
6
� 
erob
5 o   / 0�� 0 thelist theList
6 �
7�
� 
errt
7 m   1 2�
� 
list�  �  
 
8
9
8 r   6 ;
:
;
: o   6 7�� 0 oldtids oldTIDs
; n     
<
=
< 1   8 :�
� 
txdl
= 1   7 8�
� 
ascr
9 
>�
> L   < >
?
? o   < =�� 0 
resulttext 
resultText�  
 
@
A
@ l     ����  �  �  
A 
B
C
B l     ����  �  �  
C 
D
E
D l     �
F
G�  
F  -----   
G �
H
H 
 - - - - -
E 
I
J
I l     �
�	��
  �	  �  
J 
K
L
K i  s v
M
N
M I     �
O
P
� .Txt:SplTnull���     ctxt
O o      �� 0 thetext theText
P �
Q
R
� 
Sepa
Q |��
S�
T�  �  
S o      �� 0 theseparator theSeparator�  
T l     
U� ��
U m      ��
�� 
msng�   ��  
R ��
V��
�� 
Usin
V |����
W��
X��  ��  
W o      ���� 0 matchformat matchFormat��  
X l     
Y����
Y m      ��
�� SerECmpI��  ��  ��  
N k     �
Z
Z 
[
\
[ l     ��
]
^��  
]rl convenience handler for splitting text using TIDs that can also use a regular expression pattern as separator; note that this is similar to using `search text theText for theSeparator returning non matching text` (except that `search text` returns start and end indexes as well as text), but avoids some of the overhead and is an obvious complement to `join text`   
^ �
_
_�   c o n v e n i e n c e   h a n d l e r   f o r   s p l i t t i n g   t e x t   u s i n g   T I D s   t h a t   c a n   a l s o   u s e   a   r e g u l a r   e x p r e s s i o n   p a t t e r n   a s   s e p a r a t o r ;   n o t e   t h a t   t h i s   i s   s i m i l a r   t o   u s i n g   ` s e a r c h   t e x t   t h e T e x t   f o r   t h e S e p a r a t o r   r e t u r n i n g   n o n   m a t c h i n g   t e x t `   ( e x c e p t   t h a t   ` s e a r c h   t e x t `   r e t u r n s   s t a r t   a n d   e n d   i n d e x e s   a s   w e l l   a s   t e x t ) ,   b u t   a v o i d s   s o m e   o f   t h e   o v e r h e a d   a n d   i s   a n   o b v i o u s   c o m p l e m e n t   t o   ` j o i n   t e x t `
\ 
`��
` Q     �
a
b
c
a k    �
d
d 
e
f
e r    
g
h
g n   
i
j
i I    ��
k���� "0 astextparameter asTextParameter
k 
l
m
l o    	���� 0 thetext theText
m 
n��
n m   	 

o
o �
p
p  ��  ��  
j o    ���� 0 _supportlib _supportLib
h o      ���� 0 thetext theText
f 
q��
q Z    �
r
s
t
u
r =   
v
w
v o    ���� 0 theseparator theSeparator
w m    ��
�� 
msng
s l   
x
y
z
x L    
{
{ I    ��
|���� 0 _splitpattern _splitPattern
| 
}
~
} o    ���� 0 thetext theText
~ 
��
 m    
�
� �
�
�  \ s +��  ��  
y g a if `at` parameter is omitted, splits on whitespace runs by default, ignoring any `using` options   
z �
�
� �   i f   ` a t `   p a r a m e t e r   i s   o m i t t e d ,   s p l i t s   o n   w h i t e s p a c e   r u n s   b y   d e f a u l t ,   i g n o r i n g   a n y   ` u s i n g `   o p t i o n s
t 
�
�
� =  " %
�
�
� o   " #���� 0 matchformat matchFormat
� m   # $��
�� SerECmpI
� 
�
�
� P   ( 6
�
�
�
� L   - 5
�
� I   - 4��
����� 0 
_splittext 
_splitText
� 
�
�
� o   . /���� 0 thetext theText
� 
���
� o   / 0���� 0 theseparator theSeparator��  ��  
� ��
�
�� consdiac
� ��
�
�� conshyph
� ��
�
�� conspunc
� ��
�
�� conswhit
� ����
�� consnume��  
� ����
�� conscase��  
� 
�
�
� =  9 <
�
�
� o   9 :���� 0 matchformat matchFormat
� m   : ;��
�� SerECmpP
� 
�
�
� L   ? Q
�
� I   ? P��
����� 0 _splitpattern _splitPattern
� 
�
�
� o   @ A���� 0 thetext theText
� 
���
� n  A L
�
�
� I   F L��
����� "0 astextparameter asTextParameter
� 
�
�
� o   F G���� 0 theseparator theSeparator
� 
���
� m   G H
�
� �
�
�  a t��  ��  
� o   A F���� 0 _supportlib _supportLib��  ��  
� 
�
�
� =  T W
�
�
� o   T U���� 0 matchformat matchFormat
� m   U V��
�� SerECmpC
� 
�
�
� P   Z h
�
���
� L   _ g
�
� I   _ f��
����� 0 
_splittext 
_splitText
� 
�
�
� o   ` a���� 0 thetext theText
� 
���
� o   a b���� 0 theseparator theSeparator��  ��  
� ��
�
�� conscase
� ��
�
�� consdiac
� ��
�
�� conshyph
� ��
�
�� conspunc
� ��
�
�� conswhit
� ����
�� consnume��  ��  
� 
�
�
� =  k n
�
�
� o   k l���� 0 matchformat matchFormat
� m   l m��
�� SerECmpD
� 
���
� L   q y
�
� I   q x��
����� 0 
_splittext 
_splitText
� 
�
�
� o   r s���� 0 thetext theText
� 
���
� o   s t���� 0 theseparator theSeparator��  ��  ��  
u n  | �
�
�
� I   � ���
����� >0 throwinvalidparameterconstant throwInvalidParameterConstant
� 
�
�
� o   � ����� 0 matchformat matchFormat
� 
���
� m   � �
�
� �
�
� 
 u s i n g��  ��  
� o   | ����� 0 _supportlib _supportLib��  
b R      ��
�
�
�� .ascrerr ****      � ****
� o      ���� 0 etext eText
� ��
�
�
�� 
errn
� o      ���� 0 enumber eNumber
� ��
�
�
�� 
erob
� o      ���� 0 efrom eFrom
� ��
���
�� 
errt
� o      ���� 
0 eto eTo��  
c I   � ���
����� 
0 _error  
� 
�
�
� m   � �
�
� �
�
�  s p l i t   t e x t
� 
�
�
� o   � ����� 0 etext eText
� 
�
�
� o   � ����� 0 enumber eNumber
� 
�
�
� o   � ����� 0 efrom eFrom
� 
���
� o   � ����� 
0 eto eTo��  ��  ��  
L 
�
�
� l     ��������  ��  ��  
� 
�
�
� l     ��������  ��  ��  
� 
�
�
� i  w z
�
�
� I     ��
�
�
�� .Txt:JoiTnull���     ****
� o      ���� 0 thelist theList
� ��
���
�� 
Sepa
� |����
���
���  ��  
� o      ���� 0 separatortext separatorText��  
� m      
�
� �
�
�  ��  
� Q     '
�
�
�
� L    
�
� I    ��
����� 0 	_jointext 	_joinText
� 
�
�
� o    ���� 0 thelist theList
� 
���
� n   
�
�
� I   
 ��
����� "0 astextparameter asTextParameter
� 
�
�
� o   
 ���� 0 separatortext separatorText
� 
���
� m    
�
� �
�
�  u s i n g   s e p a r a t o r��  ��  
� o    
���� 0 _supportlib _supportLib��  ��  
� R      ��
�
�
�� .ascrerr ****      � ****
� o      ���� 0 etext eText
� �� 
�� 
errn  o      ���� 0 enumber eNumber ��
�� 
erob o      ���� 0 efrom eFrom ����
�� 
errt o      ���� 
0 eto eTo��  
� I    '��~� 
0 _error    m     �		  j o i n   t e x t 

 o     �}�} 0 etext eText  o     !�|�| 0 enumber eNumber  o   ! "�{�{ 0 efrom eFrom �z o   " #�y�y 
0 eto eTo�z  �~  
�  l     �x�w�v�x  �w  �v    l     �u�t�s�u  �t  �s    i  { ~ I     �r�q
�r .Txt:SplPnull���     ctxt o      �p�p 0 thetext theText�q   Q     $ L     n     2   �o
�o 
cpar n    !  I    �n"�m�n "0 astextparameter asTextParameter" #$# o    	�l�l 0 thetext theText$ %�k% m   	 
&& �''  �k  �m  ! o    �j�j 0 _supportlib _supportLib R      �i()
�i .ascrerr ****      � ****( o      �h�h 0 etext eText) �g*+
�g 
errn* o      �f�f 0 enumber eNumber+ �e,-
�e 
erob, o      �d�d 0 efrom eFrom- �c.�b
�c 
errt. o      �a�a 
0 eto eTo�b   I    $�`/�_�` 
0 _error  / 010 m    22 �33   s p l i t   p a r a g r a p h s1 454 o    �^�^ 0 etext eText5 676 o    �]�] 0 enumber eNumber7 898 o    �\�\ 0 efrom eFrom9 :�[: o     �Z�Z 
0 eto eTo�[  �_   ;<; l     �Y�X�W�Y  �X  �W  < =>= l     �V�U�T�V  �U  �T  > ?@? i   �ABA I     �SCD
�S .Txt:JoiPnull���     ****C o      �R�R 0 thelist theListD �QE�P
�Q 
LiBrE |�O�NF�MG�O  �N  F o      �L�L 0 linebreaktype lineBreakType�M  G l     H�K�JH m      �I
�I LiBrLiOX�K  �J  �P  B Q     OIJKI k    =LL MNM Z    4OPQRO =   STS o    �H�H 0 linebreaktype lineBreakTypeT m    �G
�G LiBrLiOXP r   	 UVU 1   	 
�F
�F 
lnfdV o      �E�E 0 separatortext separatorTextQ WXW =   YZY o    �D�D 0 linebreaktype lineBreakTypeZ m    �C
�C LiBrLiCMX [\[ r    ]^] o    �B
�B 
ret ^ o      �A�A 0 separatortext separatorText\ _`_ =   aba o    �@�@ 0 linebreaktype lineBreakTypeb m    �?
�? LiBrLiWi` c�>c r   ! &ded b   ! $fgf o   ! "�=
�= 
ret g 1   " #�<
�< 
lnfde o      �;�; 0 separatortext separatorText�>  R n  ) 4hih I   . 4�:j�9�: >0 throwinvalidparameterconstant throwInvalidParameterConstantj klk o   . /�8�8 0 linebreaktype lineBreakTypel m�7m m   / 0nn �oo 
 u s i n g�7  �9  i o   ) .�6�6 0 _supportlib _supportLibN p�5p L   5 =qq I   5 <�4r�3�4 0 	_jointext 	_joinTextr sts o   6 7�2�2 0 thelist theListt u�1u o   7 8�0�0 0 separatortext separatorText�1  �3  �5  J R      �/vw
�/ .ascrerr ****      � ****v o      �.�. 0 etext eTextw �-xy
�- 
errnx o      �,�, 0 enumber eNumbery �+z{
�+ 
erobz o      �*�* 0 efrom eFrom{ �)|�(
�) 
errt| o      �'�' 
0 eto eTo�(  K I   E O�&}�%�& 
0 _error  } ~~ m   F G�� ���  j o i n   p a r a g r a p h s ��� o   G H�$�$ 0 etext eText� ��� o   H I�#�# 0 enumber eNumber� ��� o   I J�"�" 0 efrom eFrom� ��!� o   J K� �  
0 eto eTo�!  �%  @ ��� l     ����  �  �  � ��� l     ����  �  �  �       !����������������������������������  � �����������
�	��������� ��������������������
� 
pimr� (0 _unmatchedtexttype _UnmatchedTextType� $0 _matchedtexttype _MatchedTextType� &0 _matchedgrouptype _MatchedGroupType� 0 _supportlib _supportLib� 
0 _error  � 60 _compileregularexpression _compileRegularExpression� $0 _matchinforecord _matchInfoRecord� 0 _matchrecords _matchRecords� &0 _matchedgrouplist _matchedGroupList�
 0 _findpattern _findPattern�	 "0 _replacepattern _replacePattern� 0 	_findtext 	_findText� 0 _replacetext _replaceText
� .Txt:Srchnull���     ctxt
� .Txt:EPatnull���     ctxt
� .Txt:ETemnull���     ctxt� 0 	_pinindex 	_pinIndex
� .Txt:UppTnull���     ctxt
� .Txt:CapTnull���     ctxt
�  .Txt:LowTnull���     ctxt
�� .Txt:PadTnull���     ctxt
�� .Txt:SliTnull���     ctxt
�� .Txt:TrmTnull���     ctxt�� 0 
_splittext 
_splitText�� 0 _splitpattern _splitPattern�� 0 	_jointext 	_joinText
�� .Txt:SplTnull���     ctxt
�� .Txt:JoiTnull���     ****
�� .Txt:SplPnull���     ctxt
�� .Txt:JoiPnull���     ****� ����� �  �� �����
�� 
cobj� ��   �� 
�� 
frmk��  
� 
TxtU
� 
TxtM
� 
TxtG� ��   �� A
�� 
scpt� �� K���������� 
0 _error  �� ����� �  ������������ 0 handlername handlerName�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo��  � ������������ 0 handlername handlerName�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo�  [������ �� &0 throwcommanderror throwCommandError�� b  ࠡ����+ � �� y���������� 60 _compileregularexpression _compileRegularExpression�� ����� �  ���� 0 patterntext patternText��  � ������ 0 patterntext patternText�� 
0 regexp  � 	���������������� �
�� misccura�� *0 nsregularexpression NSRegularExpression
�� 
msng�� Z0 +regularexpressionwithpattern_options_error_ +regularExpressionWithPattern_options_error_
�� 
errn���Y
�� 
erob�� �� #��,�j�m+ E�O��  )�����Y hO�� �� ����������� $0 _matchinforecord _matchInfoRecord�� ����� �  ���������� 0 
asocstring 
asocString��  0 asocmatchrange asocMatchRange�� 0 
textoffset 
textOffset�� 0 
recordtype 
recordType��  � �������������� 0 
asocstring 
asocString��  0 asocmatchrange asocMatchRange�� 0 
textoffset 
textOffset�� 0 
recordtype 
recordType�� 0 	foundtext 	foundText��  0 nexttextoffset nextTextOffset� ������������������ *0 substringwithrange_ substringWithRange_
�� 
ctxt
�� 
leng
�� 
pcls�� 0 
startindex 
startIndex�� 0 endindex endIndex�� 0 	foundtext 	foundText�� �� $��k+  �&E�O���,E�O���k���lv� �� ����������� 0 _matchrecords _matchRecords�� ����� �  �������������� 0 
asocstring 
asocString��  0 asocmatchrange asocMatchRange��  0 asocstartindex asocStartIndex�� 0 
textoffset 
textOffset�� (0 nonmatchrecordtype nonMatchRecordType�� "0 matchrecordtype matchRecordType��  � ������������������������ 0 
asocstring 
asocString��  0 asocmatchrange asocMatchRange��  0 asocstartindex asocStartIndex�� 0 
textoffset 
textOffset�� (0 nonmatchrecordtype nonMatchRecordType�� "0 matchrecordtype matchRecordType��  0 asocmatchstart asocMatchStart�� 0 asocmatchend asocMatchEnd�� &0 asocnonmatchrange asocNonMatchRange�� 0 nonmatchinfo nonMatchInfo�� 0 	matchinfo 	matchInfo� ������������ 0 location  �� 
0 length  �� �� $0 _matchinforecord _matchInfoRecord
�� 
cobj�� W�j+  E�O��j+ E�O�ᦢ�E�O*�����+ E[�k/E�Z[�l/E�ZO*�����+ E[�k/E�Z[�l/E�ZO�����v� ��H���������� &0 _matchedgrouplist _matchedGroupList�� ����� �  ���������� 0 
asocstring 
asocString�� 0 	asocmatch 	asocMatch�� 0 
textoffset 
textOffset�� &0 includenonmatches includeNonMatches��  � ���������������������������� 0 
asocstring 
asocString�� 0 	asocmatch 	asocMatch�� 0 
textoffset 
textOffset�� &0 includenonmatches includeNonMatches�� "0 submatchresults subMatchResults�� 0 groupindexes groupIndexes�� (0 asocfullmatchrange asocFullMatchRange�� &0 asocnonmatchstart asocNonMatchStart�� $0 asocfullmatchend asocFullMatchEnd�� 0 i  �� 0 nonmatchinfo nonMatchInfo�� 0 	matchinfo 	matchInfo�� &0 asocnonmatchrange asocNonMatchRange� 	�������������������  0 numberofranges numberOfRanges�� 0 rangeatindex_ rangeAtIndex_�� 0 location  �� 
0 length  �� �� 0 _matchrecords _matchRecords
�� 
cobj�� � $0 _matchinforecord _matchInfoRecord�� �jvE�O�j+  kE�O�j ��jk+ E�O�j+ E�O��j+ E�O Uk�kh 	*���k+ ��b  b  �+ E[�k/E�Z[�l/E�Z[�m/E�Z[��/E�ZO� 	��6FY hO��6F[OY��O� #�㨧�E�O*���b  �+ �k/�6FY hY hO�� �~��}�|���{�~ 0 _findpattern _findPattern�} �z��z �  �y�x�w�v�y 0 thetext theText�x 0 patterntext patternText�w &0 includenonmatches includeNonMatches�v  0 includematches includeMatches�|  � �u�t�s�r�q�p�o�n�m�l�k�j�i�h�g�u 0 thetext theText�t 0 patterntext patternText�s &0 includenonmatches includeNonMatches�r  0 includematches includeMatches�q 
0 regexp  �p 0 
asocstring 
asocString�o &0 asocnonmatchstart asocNonMatchStart�n 0 
textoffset 
textOffset�m 0 
resultlist 
resultList�l  0 asocmatcharray asocMatchArray�k 0 i  �j 0 	asocmatch 	asocMatch�i 0 nonmatchinfo nonMatchInfo�h 0 	matchinfo 	matchInfo�g 0 	foundtext 	foundText� ��f��e�d�c�b�a�`�_�^�]�\�[�Z�Y�X�W�V�U�T�S�R�Q�P�O�f (0 asbooleanparameter asBooleanParameter�e 60 _compileregularexpression _compileRegularExpression
�d misccura�c 0 nsstring NSString�b &0 stringwithstring_ stringWithString_�a 
0 length  �` @0 matchesinstring_options_range_ matchesInString_options_range_�_ 	0 count  �^  0 objectatindex_ objectAtIndex_�] 0 rangeatindex_ rangeAtIndex_�\ �[ 0 _matchrecords _matchRecords
�Z 
cobj�Y �X 0 foundgroups foundGroups�W 0 
startindex 
startIndex�V &0 _matchedgrouplist _matchedGroupList�U *0 substringfromindex_ substringFromIndex_
�T 
ctxt
�S 
pcls�R 0 endindex endIndex
�Q 
leng�P 0 	foundtext 	foundText�O �{b  ��l+ E�Ob  ��l+ E�O*�k+ E�O��,�k+ E�OjE�OkE�OjvE�O��jj�j+ lvm+ E�O j�j+ 	kkh 
��k+ 
E�O*��jk+ ��b  b  �+ E[�k/E�Z[�l/E�Z[�m/E�Z[��/E�ZO� 	��6FY hO� �a *���a ,��+ l%�6FY h[OY��O� 1��k+ a &E�Oa b  a �a �a ,a �a �6FY hO�� �N��M�L���K�N "0 _replacepattern _replacePattern�M �J��J �  �I�H�G�I 0 thetext theText�H 0 patterntext patternText�G 0 templatetext templateText�L  � �F�E�D�C�B�F 0 thetext theText�E 0 patterntext patternText�D 0 templatetext templateText�C 0 
asocstring 
asocString�B 
0 regexp  � �A�@�?�>�=�<�;
�A misccura�@ 0 nsstring NSString�? &0 stringwithstring_ stringWithString_�> 60 _compileregularexpression _compileRegularExpression�= 
0 length  �< �; |0 <stringbyreplacingmatchesinstring_options_range_withtemplate_ <stringByReplacingMatchesInString_options_range_withTemplate_�K &��,�k+ E�O*�k+ E�O��jj�j+ lv��+ � �:�9�8���7�: 0 	_findtext 	_findText�9 �6��6 �  �5�4�3�2�5 0 thetext theText�4 0 fortext forText�3 &0 includenonmatches includeNonMatches�2  0 includematches includeMatches�8  � 
�1�0�/�.�-�,�+�*�)�(�1 0 thetext theText�0 0 fortext forText�/ &0 includenonmatches includeNonMatches�.  0 includematches includeMatches�- 0 
resultlist 
resultList�, 0 oldtids oldTIDs�+ 0 
startindex 
startIndex�* 0 endindex endIndex�) 0 	foundtext 	foundText�( 0 i  � �'�&�%�$�#�"�!� �Q����������
�' 
errn�&�Y
�% 
erob�$ 
�# 
ascr
�" 
txdl
�! 
citm
�  
leng
� 
ctxt
� 
pcls� 0 
startindex 
startIndex� 0 endindex endIndex� 0 	foundtext 	foundText� 
� .corecnte****       ****� 0 foundgroups foundGroups� 
�7(��  )�����Y hOjvE�O��,E�O���,FOkE�O��k/�,E�O�� �[�\[Z�\Z�2E�Y �E�O� �b  ����a �6FY hO �l��-j kh 	�kE�O��,�[�\[�/\Zi2�,E�O�� �[�\[Z�\Z�2E�Y a E�O� �b  ����a jva �6FY hO�kE�O���/�,kE�O�� �[�\[Z�\Z�2E�Y a E�O� �b  ����a �6FY h[OY�XO���,FO�� �������� 0 _replacetext _replaceText� ��� �  ���� 0 thetext theText� 0 fortext forText� 0 newtext newText�  � �����
�	� 0 thetext theText� 0 fortext forText� 0 newtext newText� 0 oldtids oldTIDs�
 0 	textitems 	textItems�	 0 
resulttext 
resultText� ����
� 
ascr
� 
txdl
� 
citm
� 
ctxt� '��,E�O���,FO��-E�O���,FO��&E�O���,FO�� �6�����
� .Txt:Srchnull���     ctxt� 0 thetext theText� � ���
�  
For_�� 0 fortext forText� ����
�� 
Usin� {�������� 0 matchformat matchFormat��  
�� SerECmpI� ����
�� 
Repl� {�������� 0 newtext newText��  
�� 
msng� �����
�� 
Retu� {�������� 0 resultformat resultFormat��  
�� RetEMatT��  � ������������������������ 0 thetext theText�� 0 fortext forText�� 0 matchformat matchFormat�� 0 newtext newText�� 0 resultformat resultFormat�� &0 includenonmatches includeNonMatches��  0 includematches includeMatches�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� #X��g����������t��������������������������������g���t������ "0 astextparameter asTextParameter
�� 
leng
�� 
errn���Y
�� 
erob�� 
�� 
msng
�� RetEMatT
�� 
cobj
�� RetEUmaT
�� RetEAllT�� >0 throwinvalidparameterconstant throwInvalidParameterConstant
�� SerECmpI�� 0 	_findtext 	_findText
�� SerECmpP�� 0 _findpattern _findPattern
�� SerECmpC
�� SerECmpD�� 0 _replacetext _replaceText�� "0 _replacepattern _replacePattern�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  ���b  ��l+ E�Ob  ��l+ E�O��,j  )�����Y hO��  ؤ�  felvE[�k/E�Z[�l/E�ZY E��  eflvE[�k/E�Z[�l/E�ZY )��  eelvE[�k/E�Z[�l/E�ZY b  ��l+ O�a   a a  *�����+ VY V�a   *�����+ Y A�a   a g *�����+ VY $�a   *�����+ Y b  �a l+ Y �b  �a l+ E�O�a   a a  *���m+ VY S�a   *���m+ Y ?�a   a g *���m+ VY #�a   *���m+ Y b  �a l+ W X  *a  ����a !+ "� �����������
�� .Txt:EPatnull���     ctxt�� 0 thetext theText��  � ������������ 0 thetext theText�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� �������������������
�� misccura�� *0 nsregularexpression NSRegularExpression�� "0 astextparameter asTextParameter�� 40 escapedpatternforstring_ escapedPatternForString_
�� 
ctxt�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� + ��,b  ��l+ k+ �&W X  *衢���+ 
� �����������
�� .Txt:ETemnull���     ctxt�� 0 thetext theText��  � ������������ 0 thetext theText�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� �������������������
�� misccura�� *0 nsregularexpression NSRegularExpression�� "0 astextparameter asTextParameter�� 60 escapedtemplateforstring_ escapedTemplateForString_
�� 
ctxt�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� + ��,b  ��l+ k+ �&W X  *衢���+ 
� ������������� 0 	_pinindex 	_pinIndex�� ����� �  ������ 0 theindex theIndex�� 0 
textlength 
textLength��  � ������ 0 theindex theIndex�� 0 
textlength 
textLength�  �� &�� �Y ��' �'Y �j  kY �� ��"��������
�� .Txt:UppTnull���     ctxt�� 0 thetext theText�� �����
�� 
Loca� {�������� 0 
localecode 
localeCode��  
�� 
msng��  � ���������������� 0 thetext theText�� 0 
localecode 
localeCode�� 0 
asocstring 
asocString�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ��~<�}�|�{�z�y[�x�w�v�g�u�t
� misccura�~ 0 nsstring NSString�} "0 astextparameter asTextParameter�| &0 stringwithstring_ stringWithString_
�{ 
msng�z "0 uppercasestring uppercaseString
�y 
ctxt�x &0 aslocaleparameter asLocaleParameter�w 80 uppercasestringwithlocale_ uppercaseStringWithLocale_�v 0 etext eText� �s�r�
�s 
errn�r 0 enumber eNumber� �q�p�
�q 
erob�p 0 efrom eFrom� �o�n�m
�o 
errt�n 
0 eto eTo�m  �u �t 
0 _error  �� O >��,b  ��l+ k+ E�O��  �j+ �&Y �b  ��l+ 	k+ 
�&W X  *������+ � �lw�k�j���i
�l .Txt:CapTnull���     ctxt�k 0 thetext theText�j �h��g
�h 
Loca� {�f�e�d�f 0 
localecode 
localeCode�e  
�d 
msng�g  � �c�b�a�`�_�^�]�c 0 thetext theText�b 0 
localecode 
localeCode�a 0 
asocstring 
asocString�` 0 etext eText�_ 0 enumber eNumber�^ 0 efrom eFrom�] 
0 eto eTo� �\�[��Z�Y�X�W�V��U�T�S���R�Q
�\ misccura�[ 0 nsstring NSString�Z "0 astextparameter asTextParameter�Y &0 stringwithstring_ stringWithString_
�X 
msng�W &0 capitalizedstring capitalizedString
�V 
ctxt�U &0 aslocaleparameter asLocaleParameter�T <0 capitalizedstringwithlocale_ capitalizedStringWithLocale_�S 0 etext eText� �P�O�
�P 
errn�O 0 enumber eNumber� �N�M�
�N 
erob�M 0 efrom eFrom� �L�K�J
�L 
errt�K 
0 eto eTo�J  �R �Q 
0 _error  �i O >��,b  ��l+ k+ E�O��  �j+ �&Y �b  ��l+ 	k+ 
�&W X  *������+ � �I��H�G���F
�I .Txt:LowTnull���     ctxt�H 0 thetext theText�G �E��D
�E 
Loca� {�C�B�A�C 0 
localecode 
localeCode�B  
�A 
msng�D  � �@�?�>�=�<�;�:�@ 0 thetext theText�? 0 
localecode 
localeCode�> 0 
asocstring 
asocString�= 0 etext eText�< 0 enumber eNumber�; 0 efrom eFrom�: 
0 eto eTo� �9�8��7�6�5�4�3�2�1�0��/�.
�9 misccura�8 0 nsstring NSString�7 "0 astextparameter asTextParameter�6 &0 stringwithstring_ stringWithString_
�5 
msng�4 "0 lowercasestring lowercaseString
�3 
ctxt�2 &0 aslocaleparameter asLocaleParameter�1 80 lowercasestringwithlocale_ lowercaseStringWithLocale_�0 0 etext eText� �-�,�
�- 
errn�, 0 enumber eNumber� �+�*�
�+ 
erob�* 0 efrom eFrom� �)�(�'
�) 
errt�( 
0 eto eTo�'  �/ �. 
0 _error  �F O >��,b  ��l+ k+ E�O��  �j+ �&Y �b  ��l+ 	k+ 
�&W X  *������+ � �&!�%�$���#
�& .Txt:PadTnull���     ctxt�% 0 thetext theText�$ �"�!�
�" 
toPl�! 0 toplaces toPlaces� � ��
�  
Char� {��*� 0 padchar padChar�  � ���
� 
From� {���� 0 whichend whichEnd�  
� LeTrLCha�  � 
����������� 0 thetext theText� 0 toplaces toPlaces� 0 padchar padChar� 0 whichend whichEnd� 0 	charcount 	charCount� 0 padtext padText� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� E�Q��m��
�	�y����������� � "0 astextparameter asTextParameter� (0 asintegerparameter asIntegerParameter
� 
leng
� 
errn�
�Y
�	 
erob� 
� LeTrLCha
� 
ctxt
� LeTrTCha
� LeTrBCha� >0 throwinvalidparameterconstant throwInvalidParameterConstant� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  � �  
0 _error  �# � �b  ��l+ E�Ob  ��l+ E�O���,E�O�j �Y hOb  ��l+ E�O��,j  )�����Y hO h��,���%E�[OY��O��  �[�\[Zk\Z�2�%Y a��  ��[�\[Zk\Z�2%Y J��  9�k  ��[�\[Zk\Z�2%Y �[�\[Zk\Z�l"2�%�%[�\[Zk\Z�2EY b  ��l+ W X  *a ����a + � �����������
�� .Txt:SliTnull���     ctxt�� 0 thetext theText�� ����
�� 
Idx1� {�������� 0 
startindex 
startIndex��  �� � �� ��
�� 
Idx2  {�������� 0 endindex endIndex��  ������  � ���������������� 0 thetext theText�� 0 
startindex 
startIndex�� 0 endindex endIndex�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ����1����C����X������ "0 astextparameter asTextParameter
�� 
leng�� (0 asintegerparameter asIntegerParameter�� 0 	_pinindex 	_pinIndex
�� 
ctxt�� 0 etext eText ����
�� 
errn�� 0 enumber eNumber ����
�� 
erob�� 0 efrom eFrom ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� l [b  ��l+ E�O��,j  �Y hO*b  ��l+ ��,l+ E�O*b  ��l+ ��,l+ E�O�[�\[Z�\Z�2EW X 	 
*룤���+ � ��h������
�� .Txt:TrmTnull���     ctxt�� 0 thetext theText�� ����
�� 
From {�������� 0 whichend whichEnd��  
�� LeTrBCha��   ������������������ 0 thetext theText�� 0 whichend whichEnd�� 0 
startindex 
startIndex�� 0 endindex endIndex�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo }�������������������������������� "0 astextparameter asTextParameter
�� LeTrLCha
�� LeTrTCha
�� LeTrBCha�� >0 throwinvalidparameterconstant throwInvalidParameterConstant
�� 
cobj
�� 
cha 
�� 
ctxt�� 0 etext eText ����
�� 
errn�� 0 enumber eNumber ����	
�� 
erob�� 0 efrom eFrom	 ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� � �b  ��l+ E�O���mv�kv b  ��l+ Y hO�� {��  �Y hOkilvE[�k/E�Z[�l/E�ZO��lv�kv  h��/� �kE�[OY��Y hO��lv�kv  h��/� �kE�[OY��Y hO�[�\[Z�\Z�2EVW X  *a ����a + � ��	����
���� 0 
_splittext 
_splitText�� ����   ������ 0 thetext theText�� 0 theseparator theSeparator��  
 �������������� 0 thetext theText�� 0 theseparator theSeparator�� 0 delimiterlist delimiterList�� 0 aref aRef�� 0 oldtids oldTIDs�� 0 
resultlist 
resultList ��������������	I	M�������������� "0 aslistparameter asListParameter
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
pcnt
�� 
ctxt��   ������
�� 
errn���\��  
�� 
list�� �� 60 throwinvalidparametertype throwInvalidParameterType
�� 
ascr
�� 
txdl
�� 
citm�� _b  �k+  E�O 5�[��l kh  ��,�&��,FW X  b  �����+ [OY��O��,E�O���,FO��-E�O���,FO�� ��	s�������� 0 _splitpattern _splitPattern�� ����   ������ 0 thetext theText�� 0 patterntext patternText��   
���������������������� 0 thetext theText�� 0 patterntext patternText�� 
0 regexp  �� 0 
asocstring 
asocString�� &0 asocnonmatchstart asocNonMatchStart�� 0 
resultlist 
resultList��  0 asocmatcharray asocMatchArray�� 0 i  ��  0 asocmatchrange asocMatchRange��  0 asocmatchstart asocMatchStart ������������~�}�|�{�z�y�x�w�� 60 _compileregularexpression _compileRegularExpression
�� misccura�� 0 nsstring NSString�� &0 stringwithstring_ stringWithString_�� 
0 length  � @0 matchesinstring_options_range_ matchesInString_options_range_�~ 	0 count  �}  0 objectatindex_ objectAtIndex_�| 0 rangeatindex_ rangeAtIndex_�{ 0 location  �z �y *0 substringwithrange_ substringWithRange_
�x 
ctxt�w *0 substringfromindex_ substringFromIndex_�� �*�k+  E�O��,�k+ E�OjE�OjvE�O��jj�j+ lvm+ E�O Fj�j+ kkh ��k+ jk+ E�O�j+ 	E�O��䩤�k+ �&�6FO��j+ E�[OY��O��k+ �&�6FO�� �v
�u�t�s�v 0 	_jointext 	_joinText�u �r�r   �q�p�q 0 thelist theList�p 0 separatortext separatorText�t   �o�n�m�l�k�o 0 thelist theList�n 0 separatortext separatorText�m 0 oldtids oldTIDs�l 0 delimiterlist delimiterList�k 0 
resulttext 
resultText �j�i�h�g�f�e�d�c�b�a�`
1
�j 
ascr
�i 
txdl�h "0 aslistparameter asListParameter
�g 
ctxt�f   �_�^�]
�_ 
errn�^�\�]  
�e 
errn�d�Y
�c 
erob
�b 
errt
�a 
list�` �s ?��,E�O���,FO b  �k+ �&E�W X  ���,FO)�������O���,FO�� �\
N�[�Z�Y
�\ .Txt:SplTnull���     ctxt�[ 0 thetext theText�Z �X
�X 
Sepa {�W�V�U�W 0 theseparator theSeparator�V  
�U 
msng �T�S
�T 
Usin {�R�Q�P�R 0 matchformat matchFormat�Q  
�P SerECmpI�S   �O�N�M�L�K�J�I�O 0 thetext theText�N 0 theseparator theSeparator�M 0 matchformat matchFormat�L 0 etext eText�K 0 enumber eNumber�J 0 efrom eFrom�I 
0 eto eTo 
o�H�G
��F�E
�
��D�C
��B
��A
��@�?
��>�=�H "0 astextparameter asTextParameter
�G 
msng�F 0 _splitpattern _splitPattern
�E SerECmpI�D 0 
_splittext 
_splitText
�C SerECmpP
�B SerECmpC
�A SerECmpD�@ >0 throwinvalidparameterconstant throwInvalidParameterConstant�? 0 etext eText �<�;
�< 
errn�; 0 enumber eNumber �:�9
�: 
erob�9 0 efrom eFrom �8�7�6
�8 
errt�7 
0 eto eTo�6  �> �= 
0 _error  �Y � �b  ��l+ E�O��  *��l+ Y g��  �� *��l+ VY P��  *�b  ��l+ l+ Y 5��  �g *��l+ VY ��  *��l+ Y b  ��l+ W X  *a ����a + � �5
��4�3�2
�5 .Txt:JoiTnull���     ****�4 0 thelist theList�3 �1�0
�1 
Sepa {�/�.
��/ 0 separatortext separatorText�.  �0   �-�,�+�*�)�(�- 0 thelist theList�, 0 separatortext separatorText�+ 0 etext eText�* 0 enumber eNumber�) 0 efrom eFrom�( 
0 eto eTo 
��'�&�% �$�#�' "0 astextparameter asTextParameter�& 0 	_jointext 	_joinText�% 0 etext eText  �"�!!
�" 
errn�! 0 enumber eNumber! � �"
�  
erob� 0 efrom eFrom" ���
� 
errt� 
0 eto eTo�  �$ �# 
0 _error  �2 ( *�b  ��l+ l+ W X  *墣���+ � ���#$�
� .Txt:SplPnull���     ctxt� 0 thetext theText�  # ������ 0 thetext theText� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo$ &���%2��� "0 astextparameter asTextParameter
� 
cpar� 0 etext eText% ��&
� 
errn� 0 enumber eNumber& ��
'
� 
erob�
 0 efrom eFrom' �	��
�	 
errt� 
0 eto eTo�  � � 
0 _error  � % b  ��l+ �-EW X  *塢���+ � �B��()�
� .Txt:JoiPnull���     ****� 0 thelist theList� �*�
� 
LiBr* {� �����  0 linebreaktype lineBreakType��  
�� LiBrLiOX�  ( ���������������� 0 thelist theList�� 0 linebreaktype lineBreakType�� 0 separatortext separatorText�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo) ����������n������+�����
�� LiBrLiOX
�� 
lnfd
�� LiBrLiCM
�� 
ret 
�� LiBrLiWi�� >0 throwinvalidparameterconstant throwInvalidParameterConstant�� 0 	_jointext 	_joinText�� 0 etext eText+ ����,
�� 
errn�� 0 enumber eNumber, ����-
�� 
erob�� 0 efrom eFrom- ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  � P ?��  �E�Y '��  �E�Y ��  
��%E�Y b  ��l+ O*��l+ W X  	*꣤���+  ascr  ��ޭ